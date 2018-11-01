module "ecs_correspondence_api_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.ecs-correspondence-api"
  service = "ecs-tasks"
}

resource "aws_iam_role_policy_attachment" "ecs_task_s3_access" {
  policy_arn = "${aws_iam_policy.ecs-correspondence-policy.arn}"
  role       = "${module.ecs_correspondence_api_role.role_name}"
}