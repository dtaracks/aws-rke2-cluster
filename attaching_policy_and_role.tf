resource "aws_iam_policy_attachment" "attach-policy" {
  name       = "attach-policy-${var.instance_name_prefix}-${random_string.suffix.result}"
  roles      = ["${aws_iam_role.ec2_ebs_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}
