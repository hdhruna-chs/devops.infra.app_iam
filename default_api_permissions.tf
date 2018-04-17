########################################################################################################
# Policy / attachment provide ability for default api user                                             #
########################################################################################################


# Role: ecs-default-api
# Purpose: Role for the ECS default api task
# Due to the dependency of api_service module call on this role, I have to leave this role declaration
# in the same file as it.
module "ecs_default_api_role" {
  source  = "git::https://bitbucket.org/corvestadevops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "ecs-default-api"
  service = "ecs-tasks"
}
