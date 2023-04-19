resource "aws_iam_policy" "policy" {
  name        = "policy-${var.instance_name_prefix}-${random_string.suffix.result}"
  description = "A policy for EBS"
  policy      = "${file("policyebs.json")}"
}
