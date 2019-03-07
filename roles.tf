module "ec2_logstash_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.ec2-logstash"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_elasticsearch_read_only" {
  role       = "${module.ec2_logstash_role.role_name}"
  policy_arn = "${module.read_elasticsearch_policy.policy_arn}"
}

resource "aws_iam_role_policy_attachment" "policy_elasticsearch_read_write" {
  role       = "${module.ec2_logstash_role.role_name}"
  policy_arn = "${module.read_write_elasticsearch_policy.policy_arn}"
}

resource "aws_iam_role_policy_attachment" "ec2_logstash_metadata" {
  policy_arn = "${module.policy_read_instance_metadata.policy_arn}"
  role       = "${module.ec2_logstash_role.role_name}"
}

resource "aws_iam_role_policy_attachment" "logstash_consul_autojoin" {
  policy_arn = "${aws_iam_policy.logstash_consul_autojoin.arn}"
  role       = "${module.ec2_logstash_role.role_name}"
}

# Role: rabbitmq
# Purpose: rabbitmq role for EC2 instances

module "rabbitmq_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.rabbitmq"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "rabbitmq_auto_clustering" {
  policy_arn = "${aws_iam_policy.rabbitmq_auto_clustering.arn}"
  role       = "${module.rabbitmq_role.role_name}"
}



# Role: nexpose_scanner
# Purpose: nexpose scanner role for EC2 instances

module "nexpose_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.nexpose"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "nexpose_scanning" {
  policy_arn = "${aws_iam_policy.nexpose_scanning.arn}"
  role       = "${module.nexpose_role.role_name}"
}

# Role: ec2-vault
# Purpose: Role for Vault EC2 instances

module "ec2_vault_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.vault"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_vault_ec2_read_only" {
  role       = "${module.ec2_vault_role.role_name}"
  policy_arn = "${module.policy_read_instance_metadata.policy_arn}"
}

resource "aws_iam_role_policy_attachment" "policy_vault_s3" {
  role       = "${module.ec2_vault_role.role_name}"
  policy_arn = "${module.policy_readwrite_vault_s3.policy_arn}"
}

# Role: ec2-mule
# Purpose: Role for Mule EC2 instances

module "ec2_mule_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.mule"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_mule_ec2_read_only" {
  role       = "${module.ec2_mule_role.role_name}"
  policy_arn = "${module.policy_read_instance_metadata.policy_arn}"
}

resource "aws_iam_role_policy_attachment" "policy_mule_ec2_app_access" {
  role       = "${module.ec2_mule_role.role_name}"
  policy_arn = "${module.policy_ec2_app_access.policy_arn}"
}

resource "aws_iam_role_policy_attachment" "policy_mule_s3" {
  role       = "${module.ec2_mule_role.role_name}"
  policy_arn = "${module.policy_readwrite_mule_s3.policy_arn}"
}




# Role: ec2-nomad
# Purpose: Role for nomad EC2 instances

module "ec2_nomad_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.nomad"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_nomad_ec2_read_only" {
  role       = "${module.ec2_nomad_role.role_name}"
  policy_arn = "${module.policy_read_instance_metadata.policy_arn}"
}

resource "aws_iam_role_policy_attachment" "policy_nomad_ecr_read_only" {
  role       = "${module.ec2_nomad_role.role_name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Role: Lambda
module "default_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.lambda-default"
  service = "lambda"
}

module "consul_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.lambda-consul"
  service = "lambda"
}

module "s3_trigger_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.lambda-trigger-s3"
  service = "lambda"
}

module "claims_input_bucket_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.claims-input-bucket"
  service = "lambda"
}

module "nginx_nlb_update_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.nginx-nlb-update"
  service = "lambda"
}

module "backup_ec2_n_delete_ami_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.backup-ec2-delete-ami"
  service = "lambda"
}
