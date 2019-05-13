module "ecs_correspondence_api_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.ecs-correspondence-api"
  service = "ecs-tasks"
}

resource "aws_iam_role_policy_attachment" "ecs_task_s3_access" {
  policy_arn = "${aws_iam_policy.ecs-correspondence-policy.arn}"
  role       = "${module.ecs_correspondence_api_role.role_name}"
}

module "ecs_s3presign_api_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.ecs-s3presign-api"
  service = "ecs-tasks"
}

resource "aws_iam_role_policy_attachment" "ecs_task_access_for_gis" {
  policy_arn = "${module.policy_readwrite_ice_s3.policy_arn}"
  role       = "${module.ecs_s3presign_api_role.role_name}"
}

module "ecs_user_management_api_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.ecs-user-management-api"
  service = "ecs-tasks"
}

resource "aws_iam_role_policy_attachment" "ecs_task_cognito_dynamo_access" {
  policy_arn = "${aws_iam_policy.ecs-user-management-policy.arn}"
  role       = "${module.ecs_user_management_api_role.role_name}"
}