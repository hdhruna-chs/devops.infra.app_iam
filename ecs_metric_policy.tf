#ECS Metric role Policy
resource "aws_iam_role_policy_attachment" "ecs_metric_lambda_vpc_access" {
  role       = module.ecs_metric_lambda_role.role_name
  policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_metric_lambda" {
  role       = module.ecs_metric_lambda_role.role_name
  policy_arn = aws_iam_policy.ecs_metric_lambda_policy.arn
}

resource "aws_iam_policy" "ecs_metric_lambda_policy" {
  name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-ecs-metric-policy"
  policy = data.template_file.ecs_metric_lambda_policy.rendered
}

data "template_file" "ecs_metric_lambda_policy" {
  template = file("${path.module}/policies/ecs_metric.json.tpl")
}