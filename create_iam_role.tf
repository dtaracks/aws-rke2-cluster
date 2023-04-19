resource "aws_iam_role" "ec2_ebs_access_role" {
  name               = "role-${var.instance_name_prefix}-${random_string.suffix.result}"
  assume_role_policy = "${file("assumerolepolicy.json")}"
}
