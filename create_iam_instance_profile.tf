resource "aws_iam_instance_profile" "profile" {
  name  = "profile-${var.instance_name_prefix}-${random_string.suffix.result}"
  role = aws_iam_role.ec2_ebs_access_role.name
}
