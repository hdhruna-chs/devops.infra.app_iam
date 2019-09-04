#Ice role Policy
resource "aws_iam_role_policy_attachment" "ice_trigger_lambda_vpc_access" {
  role       = module.ice_bucket_role.role_name
  policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ice_trigger_lambda" {
  role       = module.ice_bucket_role.role_name
  policy_arn = aws_iam_policy.ice_trigger_lambda_policy.arn
}

resource "aws_iam_policy" "ice_trigger_lambda_policy" {
  name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-ice-trigger-policy"
  policy = data.template_file.ice_trigger_lambda_policy.rendered
}

data "template_file" "ice_trigger_lambda_policy" {
template = file("${path.module}/policies/s3_trigger_lambda.json.tpl")

vars = {
  env         = data.terraform_remote_state.config.outputs.run_env
  region      = data.terraform_remote_state.config.outputs.default_region
  bucket_name = data.terraform_remote_state.buckets.outputs.ice_bucket_id
  }
}

# #Ice APP policy and attachemnt
# resource "aws_iam_role_policy_attachment" "ice_trigger_lambda_vpc_access" {
#   role       = module.ice_bucket_role.role_name
#   policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
# }
#
#
# data "template_file" "ice_trigger_lambda_policy" {
# template = file("${path.module}/policies/read_write_s3_bucket.json.tpl")
#
# vars = {
#   env         = data.terraform_remote_state.config.outputs.run_env
#   region      = data.terraform_remote_state.config.outputs.default_region
#   bucket_name = data.terraform_remote_state.buckets.outputs.ice_bucket_id
#   }
# }
