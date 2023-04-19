module "vpc" {

    source = "terraform-aws-modules/vpc/aws"
    name = "vpc-${var.instance_name_prefix}-${random_string.suffix.result}"
    cidr = "10.0.0.0/16"
    azs = ["${var.region}a", "${var.region}b", "${var.region}c"]
    private_subnets = ["10.0.64.0/24", "10.0.65.0/24", "10.0.66.0/24"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

    enable_nat_gateway = false
    single_nat_gateway = true
    enable_vpn_gateway = false
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_flow_log = false
    map_public_ip_on_launch = true
}

module "nat" {
  source = "int128/nat-instance/aws"

  name                        = "nat-${var.instance_name_prefix}-${random_string.suffix.result}"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids     = module.vpc.private_route_table_ids
  use_spot_instance           = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.instance_name_prefix}-${random_string.suffix.result}"
  description = "Allow inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Sysdig Collector"
    from_port        = 9443
    to_port          = 9443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Self"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_eip" "nat" {
  network_interface = module.nat.eni_id
}
