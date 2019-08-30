#Claims role Policy
resource "aws_iam_role_policy_attachment" "claims_trigger_lambda_vpc_access" {
  role       = module.claims_bucket_role.role_name
  policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "claims_trigger_lambda" {
  role       = module.claims_bucket_role.role_name
  policy_arn = aws_iam_policy.claims_trigger_lambda_policy.arn
}

resource "aws_iam_policy" "claims_trigger_lambda_policy" {
  name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-claims-trigger-policy"
  policy = data.template_file.claims_trigger_lambda_policy.rendered
}

data "template_file" "claims_trigger_lambda_policy" {
template = file("${path.module}/policies/s3_trigger_lambda.json.tpl")

vars = {
  env         = data.terraform_remote_state.config.outputs.run_env
  region      = data.terraform_remote_state.config.outputs.default_region
  bucket_name = data.terraform_remote_state.buckets.outputs.claims_bucket
  }
}

#Claims APP policy and attachemnt
resource "aws_iam_role_policy_attachment" "claims" {
  role       = module.ecs_claims_api_role.role_name
  policy_arn = aws_iam_policy.claims_policy.arn
}

resource "aws_iam_policy" "claims_policy" {
  name   = "${data.terraform_remote_state.config.outputs.run_env}.claims-policy"
  policy = data.template_file.claims_policy.rendered
}

data "template_file" "claims_policy" {
template = file("${path.module}/policies/read_write_s3_bucket.json.tpl")

vars = {
  env         = data.terraform_remote_state.config.outputs.run_env
  region      = data.terraform_remote_state.config.outputs.default_region
  bucket_name = data.terraform_remote_state.buckets.outputs.claims_bucket
  }
}

resource "aws_iam_role_policy_attachment" "pronto" {
  role       = module.ecs_claims_api_role.role_name
  policy_arn = aws_iam_policy.pronto_policy.arn
}

resource "aws_iam_policy" "pronto_policy" {
  name   = "${data.terraform_remote_state.config.outputs.run_env}.pronto-policy"
  policy = data.template_file.pronto_policy.rendered
}

data "template_file" "pronto_policy" {
template = file("${path.module}/policies/read_write_s3_bucket.json.tpl")

vars = {
  env         = data.terraform_remote_state.config.outputs.run_env
  region      = data.terraform_remote_state.config.outputs.default_region
  bucket_name = data.terraform_remote_state.buckets.outputs.s3_pronto_provider_bucket_id
  }
}
