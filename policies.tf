#Authorizer Lambda Policies
resource "aws_iam_role_policy_attachment" "authorizer_lambda_vpc_access" {
role       = module.authorizer_lambda_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "authorizer_lambda_dynamo_access" {
role       = module.authorizer_lambda_role.role_name
policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "authorizer_lambda" {
role       = module.authorizer_lambda_role.role_name
policy_arn = aws_iam_policy.authorizer_lambda_policy.arn
}

resource "aws_iam_policy" "authorizer_lambda_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-authorizer-policy"
policy = data.template_file.authorizer_lambda_policy.rendered
}

data "template_file" "authorizer_lambda_policy" {
template = file("${path.module}/policies/authorizer_lambda.json.tpl")

    vars = {
        env     = data.terraform_remote_state.config.outputs.run_env
        region  = data.terraform_remote_state.config.outputs.default_region
        account = data.terraform_remote_state.vpc.outputs.account_id
    }
}

data "aws_iam_policy" "lambda_vpc_access_policy" {
arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
