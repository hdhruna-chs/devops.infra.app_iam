########################################################################################################
# Policy / attachment provide ability for default api user                                             #
########################################################################################################

# Role: ecs-default-api
# Purpose: Role for the ECS default api task
# Due to the dependency of api_service module call on this role, I have to leave this role declaration
# in the same file as it.
module "ecs_default_api_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.ecs-default-api"
  service = "ecs-tasks"
}

resource "aws_iam_role_policy_attachment" "ecs_task_access" {
  policy_arn = module.policy_ecs_task_access.policy_arn
  role       = module.ecs_default_api_role.role_name
}

