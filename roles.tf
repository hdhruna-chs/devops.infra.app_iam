# Role: Lambda
module "authorizer_lambda_role" {
  source  = "git::git@github.com:cinch-home-services/accel-tf-modules.git//common/iam/service_role?ref=master"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.lambda-authorizer"
  service = "lambda"
}