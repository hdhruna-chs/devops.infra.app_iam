module "ec2_logstash_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.ec2-logstash"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_elasticsearch_read_only" {
  role       = module.ec2_logstash_role.role_name
  policy_arn = module.read_elasticsearch_policy.policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_elasticsearch_read_write" {
  role       = module.ec2_logstash_role.role_name
  policy_arn = module.read_write_elasticsearch_policy.policy_arn
}

resource "aws_iam_role_policy_attachment" "ec2_logstash_metadata" {
  policy_arn = module.policy_read_instance_metadata.policy_arn
  role       = module.ec2_logstash_role.role_name
}

resource "aws_iam_role_policy_attachment" "logstash_consul_autojoin" {
  policy_arn = aws_iam_policy.logstash_consul_autojoin.arn
  role       = module.ec2_logstash_role.role_name
}

# Role: rabbitmq
# Purpose: rabbitmq role for EC2 instances

module "rabbitmq_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.rabbitmq"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "rabbitmq_auto_clustering" {
  policy_arn = aws_iam_policy.rabbitmq_auto_clustering.arn
  role       = module.rabbitmq_role.role_name
}

# Role: nexpose_scanner
# Purpose: nexpose scanner role for EC2 instances

module "nexpose_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.nexpose"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "nexpose_scanning" {
  policy_arn = aws_iam_policy.nexpose_scanning.arn
  role       = module.nexpose_role.role_name
}

# Role: alienvault
# Purpose: nexpose scanner role for EC2 instances

module "alienvault_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.alienvault"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "alienvault_ec2_perms" {
  policy_arn = aws_iam_policy.alienvault_ec2_perms.arn
  role       = module.alienvault_role.role_name
}


# Role: ec2-vault
# Purpose: Role for Vault EC2 instances

module "ec2_vault_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.vault"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_vault_ec2_read_only" {
  role       = module.ec2_vault_role.role_name
  policy_arn = module.policy_read_instance_metadata.policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_vault_s3" {
  role       = module.ec2_vault_role.role_name
  policy_arn = module.policy_readwrite_vault_s3.policy_arn
}

# Role: ec2-mule
# Purpose: Role for Mule EC2 instances

module "ec2_mule_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.mule"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_mule_ec2_read_only" {
  role       = module.ec2_mule_role.role_name
  policy_arn = module.policy_read_instance_metadata.policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_mule_ec2_app_access" {
  role       = module.ec2_mule_role.role_name
  policy_arn = module.policy_ec2_app_access.policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_mule_s3" {
  role       = module.ec2_mule_role.role_name
  policy_arn = module.policy_readwrite_mule_s3.policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_ice_s3" {
  role       = module.ec2_mule_role.role_name
  policy_arn = module.policy_readwrite_ice_s3.policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_pronto_s3" {
  role       = module.ec2_mule_role.role_name
  policy_arn = module.policy_readwrite_pronto_s3.policy_arn
}

# Role: ec2-nomad
# Purpose: Role for nomad EC2 instances

module "ec2_nomad_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.nomad"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "policy_nomad_ec2_read_only" {
  role       = module.ec2_nomad_role.role_name
  policy_arn = module.policy_read_instance_metadata.policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_nomad_ecr_read_only" {
  role       = module.ec2_nomad_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Role: alfresco

module "alfresco_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.alfresco"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "alfresco_policy" {
  role       = module.alfresco_role.role_name
  policy_arn = aws_iam_policy.alfresco_policy.arn
}

# Role: Lambda
module "default_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.lambda-default"
  service = "lambda"
}

module "consul_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.lambda-consul"
  service = "lambda"
}

module "s3_trigger_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.lambda-trigger-s3"
  service = "lambda"
}

module "s3_trigger_lambda_claims_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.lambda-trigger-claims-s3"
  service = "lambda"
}

module "authorizer_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.lambda-authorizer"
  service = "lambda"
}

module "ice_bucket_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.ice-bucket"
  service = "lambda"
}

module "claims_bucket_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.claims-bucket"
  service = "lambda"
}

module "nginx_nlb_update_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.nginx-nlb-update"
  service = "lambda"
}

module "backup_ec2_n_delete_ami_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.backup-ec2-delete-ami"
  service = "lambda"
}

module "ecs_metric_lambda_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.ecs-metric"
  service = "lambda"
}

#AWSConfig Role
module "aws_config_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=1.0.1"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.awsconfig"
  service = "config"
}

resource "aws_iam_role_policy_attachment" "policy_s3_aws_config" {
  role       = module.aws_config_role.role_name
  policy_arn = aws_iam_policy.policy_awsconfig_s3.arn
}

# Kubernetes roles
module "airflow_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_user_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.airflow"
  service = "ec2"
  user = aws_iam_role.server_role.arn
}

resource "aws_iam_role_policy_attachment" "airflow-dns" {
  role       = module.airflow_role.role_name
  policy_arn = aws_iam_policy.airflow.arn
}

module "external_dns_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_user_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.external-dns"
  service = "ec2"
  user = aws_iam_role.server_role.arn
}

resource "aws_iam_role_policy_attachment" "external-dns" {
  role       = module.external_dns_role.role_name
  policy_arn = aws_iam_policy.external-dns.arn
}

resource "aws_iam_role" "server_node" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.server_node"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.server_node.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.server_node.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.server_node.name
}



resource "aws_iam_instance_profile" "server_node" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.server_node"
  role = "${aws_iam_role.server_node.name}"
}

resource "aws_iam_role" "server_role" {
  name        = "${data.terraform_remote_state.config.outputs.run_env}.kiam-server"
  description = "Role the Kiam Server process assumes"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.server_node.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "server_node" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.server_node"
  role = "${aws_iam_role.server_node.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": "${aws_iam_role.server_role.arn}"
    },
    {
    "Effect": "Allow",
    "Action": [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup"
    ],
    "Resource": ["*"]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "server_policy_attach" {
  name       = "${data.terraform_remote_state.config.outputs.run_env}.kiam-server-attachment"
  roles      = ["${aws_iam_role.server_role.name}"]
  policy_arn = "${aws_iam_policy.server_policy.arn}"
}


module "eks_scaling_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_user_role?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.outputs.run_env}.eks_scaling"
  service = "ec2"
  user =  aws_iam_role.server_role.arn
}

resource "aws_iam_role_policy_attachment" "eks_scaling" {
  role       = module.eks_scaling_role.role_name
  policy_arn = aws_iam_policy.eks_scaling.arn
}