#Elastic search permissions

module "read_elasticsearch_policy" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//policies/read_elasticsearch?ref=1.0.1"
  name   = "${data.terraform_remote_state.config.outputs.run_env}.read-elasticsesarch"
}

module "read_write_elasticsearch_policy" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//policies/read_write_elasticsearch?ref=1.0.1"
  name   = "${data.terraform_remote_state.config.outputs.run_env}.read-write-elasticsesarch"
}

# Policy: read-instance-metadata
# Purpose: Allow read access to EC2 metadata

module "policy_read_instance_metadata" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_instance_metadata?ref=1.0.1"
  name   = "${data.terraform_remote_state.config.outputs.run_env}.app-read-instance-metadata"
}

# Policy: logstash_consul_agent_server_joim
# Purpose: Consul agents run on logstash to auto discover consul servers

resource "aws_iam_policy" "logstash_consul_autojoin" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.logstash_consul_autojoin"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["ec2:DescribeInstances"
                   ],
        "Resource": ["*"]
      }
    ]
  }
EOF

}

# Policy: rabbitmq_auto_clustering
# Purpose: Allow rabbit to use autoscaling groups

resource "aws_iam_policy" "rabbitmq_auto_clustering" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.rabbitmq_auto_clustering"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [ "autoscaling:DescribeAutoScalingInstances",
                    "ec2:DescribeInstances"],
        "Resource": ["*"]
      }
    ]
  }
EOF

}

# Policy: nexpose_scanning
# Purpose: Scan AWS environment

resource "aws_iam_policy" "nexpose_scanning" {
name = "${data.terraform_remote_state.config.outputs.run_env}.nexpose_scanning"

policy = <<EOF
{

    "Version": "2012-10-17",
    "Statement": [
      {

        "Sid": "NexposeScanEngine",
        "Effect": "Allow",
        "Action": [ "ec2:DescribeInstances",
                    "ec2:DescribeImages",
                    "ec2:DescribeAddresses"],
        "Resource": [ "*" ]
      }
    ]
  }
EOF

}

# Policy: ECS task specific role
# Purpose: ECS task role access to s3

resource "aws_iam_policy" "ecs-correspondence-policy" {
name = "${data.terraform_remote_state.config.outputs.run_env}.ecs-correspondence-policy"

policy = <<EOF
{

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "ec2:DescribeInstances",
                "iam:GetInstanceProfile",
                "iam:GetUser"
            ],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::cv-${data.terraform_remote_state.config.outputs.run_env}-correspondence/*",
                "arn:aws:s3:::cv-${data.terraform_remote_state.config.outputs.run_env}-correspondence"
            ]
        }
    ]
  }
EOF

}

# Policy: ECS task specific role
# Purpose: ECS task role access to s3

resource "aws_iam_policy" "ecs-finance-policy" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.ecs-finance-policy"

  policy = <<EOF
{

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "ec2:DescribeInstances",
                "iam:GetInstanceProfile",
                "iam:GetUser"
            ],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::cv-${data.terraform_remote_state.config.outputs.run_env}-finance/*",
                "arn:aws:s3:::cv-${data.terraform_remote_state.config.outputs.run_env}-finance"
            ]
        }
    ]
  }
EOF

}

# Policy: ECS task specific role
# Purpose: ECS task role access to cognito and user manmagement tables in DynamoDb

resource "aws_iam_policy" "ecs-user-management-policy" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.ecs-user-management-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "ecs:*",
                "ec2:*",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth"
            ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": ["cognito-idp:*"],
      "Effect": "Allow",
      "Resource":["${data.terraform_remote_state.cognito.outputs.user_pool_arn}"]
    },
    {
            "Sid": "userTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
            ],
            "Resource": "${data.terraform_remote_state.cognito.outputs.users_arn}-*"
    },
    {
        "Sid": "roleTable",
        "Effect": "Allow",
        "Action": [
            "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem"
        ],
        "Resource": "${data.terraform_remote_state.cognito.outputs.roles_arn}-*"
    },
    {
        "Sid": "audienceTable",
        "Effect": "Allow",
        "Action": [
            "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem"
        ],
        "Resource": "${data.terraform_remote_state.cognito.outputs.audience_config_arn}-*"
    },
    {
        "Sid": "permissionTable",
        "Effect": "Allow",
        "Action": [
            "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem"
        ],
        "Resource": "${data.terraform_remote_state.cognito.outputs.permissions_arn}"
    }
]
}
EOF

}

# Policy: ecs-task-access
# Purpose: Allow ECS containers access to resources

module "policy_ecs_task_access" {
source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/ecs_task?ref=1.0.1"
name   = "${data.terraform_remote_state.config.outputs.run_env}.app-ecs-task-access"
}

# Policy: ec2-app-access
# Purpose: Allow EC2 app access to resources

module "policy_ec2_app_access" {
source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/ecs_task?ref=1.0.1"
name   = "${data.terraform_remote_state.config.outputs.run_env}.ec2-app-access"
}

# Policy: readwrite-vault-s3
# Purpose: Allow readwrite access to vault S3 bucket
module "policy_readwrite_vault_s3" {
source     = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_write_s3_objects?ref=1.0.1"
name       = "${data.terraform_remote_state.config.outputs.run_env}.vault-readwrite-s3"
bucket_id  = data.terraform_remote_state.buckets.outputs.vault_bucket_id
object_key = "*"
}

# Policy: readwrite-mule-s3
# Purpose: Allow readwrite access to ice S3 bucket
module "policy_readwrite_ice_s3" {
source     = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_write_s3_objects?ref=1.0.1"
name       = "${data.terraform_remote_state.config.outputs.run_env}.ice-readwrite-s3"
bucket_id  = data.terraform_remote_state.buckets.outputs.ice_bucket_id
object_key = "*"
}

# Policy: readwrite-mule-s3
# Purpose: Allow readwrite access to mule S3 bucket
module "policy_readwrite_mule_s3" {
source     = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_write_s3_objects?ref=1.0.1"
name       = "${data.terraform_remote_state.config.outputs.run_env}.mule-readwrite-s3"
bucket_id  = data.terraform_remote_state.buckets.outputs.mule_bucket_id
object_key = "*"
}

# Purpose: Allow readwrite access to mule S3 bucket
module "policy_readwrite_pronto_s3" {
source     = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_write_s3_objects?ref=1.0.1"
name       = "${data.terraform_remote_state.config.outputs.run_env}.mule-readwrite-s3-pronto"
bucket_id  = data.terraform_remote_state.buckets.outputs.s3_pronto_provider_bucket_id
object_key = "*"
}

#########Default Lambda Role policy. #####################################
resource "aws_iam_role_policy_attachment" "lambda_default" {
role       = module.default_lambda_role.role_name
policy_arn = aws_iam_policy.lambda_default_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
role       = module.default_lambda_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_policy" "lambda_default_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-default-policy"
policy = data.template_file.lambda_policy.rendered
}

data "aws_iam_policy" "lambda_vpc_access_policy" {
arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "template_file" "lambda_policy" {
template = file("${path.module}/policies/default_lambda.json.tpl")

vars = {
env    = data.terraform_remote_state.config.outputs.run_env
region = data.terraform_remote_state.config.outputs.default_region
}
}

#Authorizer Lambda Policies
resource "aws_iam_role_policy_attachment" "authorizer_lambda_vpc_access" {
role       = module.authorizer_lambda_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "authorizer_lambda_dynamo_access" {
role       = module.authorizer_lambda_role.role_name
policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "authorizer_lambda" {
role       = module.authorizer_lambda_role.role_name
policy_arn = aws_iam_policy.authorizer_lambda_policy.arn
}

resource "aws_iam_policy" "authorizer_lambda_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-authorizer-policy"
policy = data.template_file.authorizer_lambda_policy.rendered
}

data "template_file" "authorizer_lambda_policy" {
template = file("${path.module}/policies/authorizer_lambda.json.tpl")

vars = {
env     = data.terraform_remote_state.config.outputs.run_env
region  = data.terraform_remote_state.config.outputs.default_region
account = data.terraform_remote_state.vpc.outputs.account_id
}
}

#Consul Lambda Policies
resource "aws_iam_role_policy_attachment" "consul_lambda_vpc_access" {
role       = module.consul_lambda_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "consul_lambda" {
role       = module.consul_lambda_role.role_name
policy_arn = aws_iam_policy.consul_lambda_policy.arn
}

resource "aws_iam_policy" "consul_lambda_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-consul-policy"
policy = data.template_file.consul_lambda_policy.rendered
}

data "template_file" "consul_lambda_policy" {
template = file("${path.module}/policies/consul_lambda.json.tpl")

vars = {
env    = data.terraform_remote_state.config.outputs.run_env
region = data.terraform_remote_state.config.outputs.default_region
}
}

# Alfresco
resource "aws_iam_policy" "alfresco_policy" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.alfresco-policy"
  policy = data.template_file.alfresco_policy.rendered
}

data "template_file" "alfresco_policy" {
  template = file("${path.module}/policies/alfresco.json.tpl")
  vars = {
    bucket_name = "cv-${data.terraform_remote_state.config.outputs.run_env}-alfresco-data"
  }
}

#Trigger Lambda with s3 Policy
resource "aws_iam_role_policy_attachment" "s3_trigger_lambda_vpc_access" {
role       = module.s3_trigger_lambda_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_trigger_lambda" {
role       = module.s3_trigger_lambda_role.role_name
policy_arn = aws_iam_policy.s3_trigger_lambda_policy.arn
}

resource "aws_iam_policy" "s3_trigger_lambda_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-s3_trigger-policy"
policy = data.template_file.s3_trigger_lambda_policy.rendered
}

data "template_file" "s3_trigger_lambda_policy" {
template = file("${path.module}/policies/s3_trigger_lambda.json.tpl")

vars = {
env         = data.terraform_remote_state.config.outputs.run_env
region      = data.terraform_remote_state.config.outputs.default_region
bucket_name = data.terraform_remote_state.buckets.outputs.lambda_s3_bucket_id
}
}

#Trigger Lambda with s3 for ice claims bucket
resource "aws_iam_role_policy_attachment" "ice_trigger_lambda_vpc_access" {
role       = module.claims_input_bucket_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ice_trigger_lambda" {
role       = module.claims_input_bucket_role.role_name
policy_arn = aws_iam_policy.ice_trigger_lambda_policy.arn
}

resource "aws_iam_policy" "ice_trigger_lambda_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-ice-trigger-policy"
policy = data.template_file.ice_trigger_lambda_policy.rendered
}

data "template_file" "ice_trigger_lambda_policy" {
template = file("${path.module}/policies/claims_input_bucket.json.tpl")

vars = {
env         = data.terraform_remote_state.config.outputs.run_env
region      = data.terraform_remote_state.config.outputs.default_region
bucket_name = data.terraform_remote_state.buckets.outputs.ice_bucket_id
}
}

#Nomad
resource "aws_iam_role_policy_attachment" "nomad_s3_access" {
role       = module.ec2_nomad_role.role_name
policy_arn = aws_iam_policy.nomad_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "nomad_s3_access_config" {
role       = module.ec2_nomad_role.role_name
policy_arn = aws_iam_policy.nomad_s3_access_config_policy.arn
}

resource "aws_iam_role_policy_attachment" "nomad_s3_pronto_access" {
role       = module.ec2_nomad_role.role_name
policy_arn = aws_iam_policy.nomad_s3_pronto_access_policy.arn
}

resource "aws_iam_policy" "nomad_s3_access_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.default-nomad-s3-access"
policy = data.template_file.nomad_s3_access.rendered
}

resource "aws_iam_policy" "nomad_s3_access_config_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.config-nomad-s3-access"
policy = data.template_file.nomad_s3_access_config.rendered
}

resource "aws_iam_policy" "nomad_s3_pronto_access_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.nomad_s3_pronto_access"
policy = data.template_file.nomad_s3_pronto_access.rendered
}

data "template_file" "nomad_s3_access" {
template = file("${path.module}/policies/nomad_s3_access.json.tpl")

vars = {
env         = data.terraform_remote_state.config.outputs.run_env
region      = data.terraform_remote_state.config.outputs.default_region
bucket_name = data.terraform_remote_state.buckets.outputs.ice_bucket_id
}
}

data "template_file" "nomad_s3_access_config" {
template = file("${path.module}/policies/nomad_s3_access.json.tpl")

vars = {
env         = data.terraform_remote_state.config.outputs.run_env
region      = data.terraform_remote_state.config.outputs.default_region
bucket_name = data.terraform_remote_state.buckets.outputs.claims_input_bucket
}
}

data "template_file" "nomad_s3_pronto_access" {
template = file("${path.module}/policies/nomad_s3_access.json.tpl")

vars = {
  env         = data.terraform_remote_state.config.outputs.run_env
  region      = data.terraform_remote_state.config.outputs.default_region
  bucket_name = data.terraform_remote_state.buckets.outputs.s3_pronto_provider_bucket_id
  }
}

#Nginx Update ALB under NLB

resource "aws_iam_role_policy_attachment" "nginx_nlb_update_vpc" {
role       = module.nginx_nlb_update_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "nginx_nlb_update_lambda" {
role       = module.nginx_nlb_update_role.role_name
policy_arn = aws_iam_policy.nginx_nlb_update_lambda_policy.arn
}

resource "aws_iam_policy" "nginx_nlb_update_lambda_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-nginx_nlb_update-policy"
policy = data.template_file.nginx_nlb_update_lambda_policy.rendered
}

data "template_file" "nginx_nlb_update_lambda_policy" {
template = file("${path.module}/policies/nginx_nlb_update.json.tpl")

vars = {
env         = data.terraform_remote_state.config.outputs.run_env
region      = data.terraform_remote_state.config.outputs.default_region
bucket_name = data.terraform_remote_state.buckets.outputs.nginx_nlb_proxy_bucket
}
}

# Lambda Iam Role to backup ec2 n delete ami

resource "aws_iam_role_policy_attachment" "backup_ec2_delete_ami" {
role       = module.backup_ec2_n_delete_ami_role.role_name
policy_arn = data.aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "backup_ec2_delete_ami_lambda" {
role       = module.backup_ec2_n_delete_ami_role.role_name
policy_arn = aws_iam_policy.backup_ec2_and_delete_ami_policy.arn
}

resource "aws_iam_policy" "backup_ec2_and_delete_ami_policy" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.lambda-backup_ec2_delete_ami"
policy = data.template_file.backup_ec2_and_delete_ami_policy.rendered
}

data "template_file" "backup_ec2_and_delete_ami_policy" {
template = file("${path.module}/policies/backup_ami_lambda.json.tpl")

vars = {
env    = data.terraform_remote_state.config.outputs.run_env
region = data.terraform_remote_state.config.outputs.default_region
}
}

#AWS Config
resource "aws_iam_policy" "policy_awsconfig_s3" {
name   = "${data.terraform_remote_state.config.outputs.run_env}.awsconfig_policy_awsconfig_s3"
policy = data.template_file.policy_awsconfig_s3.rendered
}

data "template_file" "policy_awsconfig_s3" {
template = file("${path.module}/policies/s3_aws_config.json.tpl")

vars = {
bucket_name = data.terraform_remote_state.buckets.outputs.aws_log_config_bucket_id
}
}


# Kubernetes Policies
resource "aws_iam_policy" "airflow" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.airflow"
  policy = data.template_file.airflow.rendered
}

data "template_file" "airflow" {
  template = file(
    "./policies/airflow_policy.json.tpl",
  )
  vars = {
    env = data.terraform_remote_state.config.outputs.run_env
    region = data.terraform_remote_state.config.outputs.default_region
  }
}

resource "aws_iam_policy" "external-dns" {
  name = "${data.terraform_remote_state.config.outputs.run_env}.external-dns"
  policy = data.template_file.external-dns.rendered
}

data "template_file" "external-dns" {
  template = file(
    "./policies/external-dns-policy.json.tpl",
  )
  vars = {
    env = data.terraform_remote_state.config.outputs.run_env
    region = data.terraform_remote_state.config.outputs.default_region
  }
}

resource "aws_iam_policy" "server_policy" {
  name        = "${data.terraform_remote_state.config.outputs.run_env}.kiam_server_policy"
  description = "Policy for the Kiam Server process"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
