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

# Policy: ecs-task-access
# Purpose: Allow ECS containers access to resources

module "policy_ecs_task_access" {
  source = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/ecs_task?ref=0.0.64"
  name   = "${data.terraform_remote_state.config.run_env}.app-ecs-task-access"
}


# Policy: readwrite-vault-s3
# Purpose: Allow readwrite access to vault S3 bucket
module "policy_readwrite_vault_s3" {
  source     = "git::https://bitbucket.org/corvesta/devops.infra.modules.git///policies/read_write_s3_objects?ref=0.0.64"
  name       = "${data.terraform_remote_state.config.run_env}.vault-readwrite-s3"
  bucket_id  = "${data.terraform_remote_state.buckets.vault_bucket_id}"
  object_key = "*"
}
