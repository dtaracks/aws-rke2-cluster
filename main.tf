provider "aws" {
  profile = var.aws_profile
  region  = var.region

  default_tags {
    tags =  merge(var.aws_tags)
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_instance" "masters" {
  for_each = var.instances_masters

  ami           = var.ami
  instance_type = var.instance_type
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  key_name = "${var.key_name}"

  tags = {
    Name = "master-${var.instance_name_prefix}-${random_string.suffix.result}"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  user_data         = data.template_cloudinit_config.server_config.rendered

}

resource "aws_instance" "workers" {
  for_each = var.instances_workers

  ami           = var.ami
  instance_type = var.instance_type
  iam_instance_profile = "${aws_iam_instance_profile.profile.name}"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  key_name = "${var.key_name}"

  tags = {
    Name = "worker-${var.instance_name_prefix}-${random_string.suffix.result}"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  user_data         = data.template_cloudinit_config.worker_config.rendered

}
