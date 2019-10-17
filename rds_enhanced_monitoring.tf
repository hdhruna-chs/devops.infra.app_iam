resource "aws_iam_role" "rds_enhanced_monitoring" {
  name  = "${data.terraform_remote_state.config.outputs.run_env}.rds-enhanced-monitoring-role"

  # Trust policy...
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role  = aws_iam_role.rds_enhanced_monitoring.name

  # Permissions policy...
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
