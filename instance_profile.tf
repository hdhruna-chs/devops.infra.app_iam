resource "aws_iam_instance_profile" "logstash_instance" {
  name = "${data.terraform_remote_state.config.run_env}.logstash-instance"
  role = "${module.ec2_logstash_role.role_name}"
}

resource "aws_iam_instance_profile" "rabbitmq" {
  name = "${data.terraform_remote_state.config.run_env}.rabbitmq"
  role = "${module.rabbitmq_role.role_name}"
}

resource "aws_iam_instance_profile" "nexpose_scanner" {
  name = "${data.terraform_remote_state.config.run_env}.nexpose_scanner"
  role = "${module.nexpose_role.role_name}"
}

resource "aws_iam_instance_profile" "vault_server" {
  name = "${data.terraform_remote_state.config.run_env}.vault-server"
  role = "${module.ec2_vault_role.role_name}"
}
