resource "aws_iam_instance_profile" "logstash_instance" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.logstash-instance"
  role = module.ec2_logstash_role.role_name
}

resource "aws_iam_instance_profile" "rabbitmq" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.rabbitmq"
  role = module.rabbitmq_role.role_name
}

resource "aws_iam_instance_profile" "nexpose_scanner" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.nexpose_scanner"
  role = module.nexpose_role.role_name
}

resource "aws_iam_instance_profile" "vault_server" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.vault-server"
  role = module.ec2_vault_role.role_name
}

resource "aws_iam_instance_profile" "mule_server" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.mule-server"
  role = module.ec2_mule_role.role_name
}

resource "aws_iam_instance_profile" "nomad_server" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.nomad-server"
  role = module.ec2_nomad_role.role_name
}

resource "aws_iam_instance_profile" "alfresco" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.alfresco-server"
  role = module.alfresco_role.role_name
}

