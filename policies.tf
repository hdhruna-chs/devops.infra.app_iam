#Elastic search permissions

module "read_elasticsearch_policy" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//policies/read_elasticsearch?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.read-elasticsesarch"
}

module "read_write_elasticsearch_policy" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//policies/read_write_elasticsearch?ref=0.0.2"
  name    = "${data.terraform_remote_state.config.run_env}.read-write-elasticsesarch"
}


# Policy: read-instance-metadata
# Purpose: Allow read access to EC2 metadata

module "policy_read_instance_metadata" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_instance_metadata?ref=0.0.86"
  name   = "${data.terraform_remote_state.config.run_env}.app-read-instance-metadata"
}

# Policy: logstash_consul_agent_server_joim
# Purpose: Consul agents run on logstash to auto discover consul servers

resource "aws_iam_policy" "logstash_consul_autojoin" {
  name = "${data.terraform_remote_state.config.run_env}.logstash_consul_autojoin"

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
  name = "${data.terraform_remote_state.config.run_env}.rabbitmq_auto_clustering"

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
  name = "${data.terraform_remote_state.config.run_env}.nexpose_scanning"

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
  name = "${data.terraform_remote_state.config.run_env}.ecs-correspondence-policy"

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
                "arn:aws:s3:::cv-${data.terraform_remote_state.config.run_env}-correspondence/*",
                "arn:aws:s3:::cv-${data.terraform_remote_state.config.run_env}-correspondence"
            ]
        }
    ]
  }
EOF
}


# Policy: ecs-task-access
# Purpose: Allow ECS containers access to resources

module "policy_ecs_task_access" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/ecs_task?ref=0.0.64"
  name   = "${data.terraform_remote_state.config.run_env}.app-ecs-task-access"
}

# Policy: ec2-app-access
# Purpose: Allow EC2 app access to resources

module "policy_ec2_app_access" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/ecs_task?ref=0.0.64"
  name   = "${data.terraform_remote_state.config.run_env}.ec2-app-access"
}


# Policy: readwrite-vault-s3
# Purpose: Allow readwrite access to vault S3 bucket
module "policy_readwrite_vault_s3" {
  source     = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_write_s3_objects?ref=0.0.64"
  name       = "${data.terraform_remote_state.config.run_env}.vault-readwrite-s3"
  bucket_id  = "${data.terraform_remote_state.buckets.vault_bucket_id}"
  object_key = "*"
}

# Policy: readwrite-mule-s3
# Purpose: Allow readwrite access to ice S3 bucket
module "policy_readwrite_mule_s3" {
  source     = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_write_s3_objects?ref=0.0.64"
  name       = "${data.terraform_remote_state.config.run_env}.mule-readwrite-s3"
  bucket_id  = "${data.terraform_remote_state.buckets.ice_bucket_id}"
  object_key = "*"
}

#########Default Lambda Role policy. #####################################
resource "aws_iam_role_policy_attachment" "lambda_default" {
  role       = "${module.default_lambda_role.role_name}"
  policy_arn = "${aws_iam_policy.lambda_default_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role   = "${module.default_lambda_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_policy" "lambda_default_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-default-policy"
  policy = "${data.template_file.lambda_policy.rendered}"
}
data "aws_iam_policy" "lambda_vpc_access_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
data "template_file" "lambda_policy" {
  template = "${file("${path.module}/policies/default_lambda.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
  }
}
#Consul Lambda Policies
resource "aws_iam_role_policy_attachment" "consul_lambda_vpc_access" {
  role   = "${module.consul_lambda_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "consul_lambda" {
  role       = "${module.consul_lambda_role.role_name}"
  policy_arn = "${aws_iam_policy.consul_lambda_policy.arn}"
}
resource "aws_iam_policy" "consul_lambda_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-consul-policy"
  policy = "${data.template_file.consul_lambda_policy.rendered}"
}
data "template_file" "consul_lambda_policy" {
  template = "${file("${path.module}/policies/consul_lambda.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
  }
}

#Trigger Lambda with s3 Policy
resource "aws_iam_role_policy_attachment" "s3_trigger_lambda_vpc_access" {
  role   = "${module.s3_trigger_lambda_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "s3_trigger_lambda" {
  role       = "${module.s3_trigger_lambda_role.role_name}"
  policy_arn = "${aws_iam_policy.s3_trigger_lambda_policy.arn}"
}
resource "aws_iam_policy" "s3_trigger_lambda_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-s3_trigger-policy"
  policy = "${data.template_file.s3_trigger_lambda_policy.rendered}"
}
data "template_file" "s3_trigger_lambda_policy" {
  template = "${file("${path.module}/policies/s3_trigger_lambda.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
    bucket_name = "${data.terraform_remote_state.buckets.lambda_s3_bucket_id}"
  }
}

#Trigger Lambda with s3 for ice claims bucket
resource "aws_iam_role_policy_attachment" "ice_trigger_lambda_vpc_access" {
  role   = "${module.claims_input_bucket_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "ice_trigger_lambda" {
  role       = "${module.claims_input_bucket_role.role_name}"
  policy_arn = "${aws_iam_policy.ice_trigger_lambda_policy.arn}"
}
resource "aws_iam_policy" "ice_trigger_lambda_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-ice-trigger-policy"
  policy = "${data.template_file.ice_trigger_lambda_policy.rendered}"
}
data "template_file" "ice_trigger_lambda_policy" {
  template = "${file("${path.module}/policies/claims_input_bucket.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
    bucket_name = "${data.terraform_remote_state.buckets.ice_bucket_id}"
  }
}


#Nomad
resource "aws_iam_role_policy_attachment" "nomad_s3_access" {
  role       = "${module.ec2_nomad_role.role_name}"
  policy_arn = "${aws_iam_policy.nomad_s3_access_policy.arn}"
}
resource "aws_iam_policy" "nomad_s3_access_policy" {
  name = "${data.terraform_remote_state.config.run_env}.default-nomad-s3-access"
  policy = "${data.template_file.nomad_s3_access.rendered}"
}

data "template_file" "nomad_s3_access" {
  template = "${file("${path.module}/policies/nomad_s3_access.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
    bucket_name = "${data.terraform_remote_state.buckets.ice_bucket_id}"
  }
}


#Nginx Update ALB under NLB

resource "aws_iam_role_policy_attachment" "nginx_nlb_update_vpc" {
  role   = "${module.nginx_nlb_update_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "nginx_nlb_update_lambda" {
  role       = "${module.nginx_nlb_update_role.role_name}"
  policy_arn = "${aws_iam_policy.nginx_nlb_update_lambda_policy.arn}"
}
resource "aws_iam_policy" "nginx_nlb_update_lambda_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-nginx_nlb_update-policy"
  policy = "${data.template_file.nginx_nlb_update_lambda_policy.rendered}"
}
data "template_file" "nginx_nlb_update_lambda_policy" {
  template = "${file("${path.module}/policies/nginx_nlb_update.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
    bucket_name = "${data.terraform_remote_state.buckets.nginx_nlb_proxy_bucket}"
  }
}

# Lambda Iam Role to backup ec2 n delete ami

resource "aws_iam_role_policy_attachment" "backup_ec2_delete_ami" {
  role   = "${module.backup_ec2_n_delete_ami_role.role_name}"
  policy_arn = "${data.aws_iam_policy.lambda_vpc_access_policy.arn}"
}
resource "aws_iam_role_policy_attachment" "backup_ec2_delete_ami_lambda" {
  role       = "${module.backup_ec2_n_delete_ami_role.role_name}"
  policy_arn = "${aws_iam_policy.backup_ec2_and_delete_ami_policy.arn}"
}
resource "aws_iam_policy" "backup_ec2_and_delete_ami_policy" {
  name = "${data.terraform_remote_state.config.run_env}.lambda-backup_ec2_delete_ami"
  policy = "${data.template_file.backup_ec2_and_delete_ami_policy.rendered}"
}
data "template_file" "backup_ec2_and_delete_ami_policy" {
  template = "${file("${path.module}/policies/backup_ami_lambda.json.tpl")}"
  vars {
    env = "${data.terraform_remote_state.config.run_env}"
    region = "${data.terraform_remote_state.config.default_region}"
  }
}
