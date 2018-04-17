#Elastic search permissions

module "read_elasticsearch_policy" {
  source  = "git::https://bitbucket.org/corvestadevops.infra.modules.git//policies/read_elasticsearch?ref=0.0.2"
  name    = "read-elasticsesarch"
}

module "read_write_elasticsearch_policy" {
  source  = "git::https://bitbucket.org/corvestadevops.infra.modules.git//policies/read_write_elasticsearch?ref=0.0.2"
  name    = "read-write-elasticsesarch"
}


# Policy: read-instance-metadata
# Purpose: Allow read access to EC2 metadata

module "policy_read_instance_metadata" {
  source = "git::https://bitbucket.org/corvestadevops/devops.infra.modules.git///policies/read_instance_metadata?ref=0.0.2"
  name   = "read-instance-metadata"
}


# Policy: rabbitmq_auto_clustering
# Purpose: Allow rabbit to use autoscaling groups

resource "aws_iam_policy" "rabbitmq_auto_clustering" {
  name = "rabbitmq_auto_clustering"

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
  name = "nexpose_scanning"

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
