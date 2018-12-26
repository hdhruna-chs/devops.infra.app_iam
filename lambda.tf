#Default Lambda Role policy
resource "aws_iam_role_policy_attachment" "lambda_default" {
  role       = "${module.default_lambda_role.role_name}"
  policy_arn = "${aws_iam_policy.lambda_default_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role   = "${module.default_lambda_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_policy" "lambda_default_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-default-policy"
  policy = "${data.template_file.lambda_policy.rendered}"
}
data "aws_iam_policy" "lambda_vpc_access_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
data "template_file" "lambda_policy" {
  template = "${file("${path.module}/policies/default_lambda.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
  }
}
#Consul Lambda Policies
resource "aws_iam_role_policy_attachment" "consul_lambda_vpc_access" {
  role   = "${module.consul_lambda_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "consul_lambda" {
  role       = "${module.consul_lambda_role.role_name}"
  policy_arn = "${aws_iam_policy.consul_lambda_policy.arn}"
}
resource "aws_iam_policy" "consul_lambda_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-consul-policy"
  policy = "${data.template_file.consul_lambda_policy.rendered}"
}
data "template_file" "consul_lambda_policy" {
  template = "${file("${path.module}/policies/consul_lambda.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
  }
}
