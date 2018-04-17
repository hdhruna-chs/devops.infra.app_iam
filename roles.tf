module "ec2_logstash_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "ec2-logstash"
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


# Role: rabbitmq
# Purpose: rabbitmq role for EC2 instances

module "rabbitmq_role" {
  source  = "git::https://bitbucket.org/corvesta/devops.infra.modules.git//common/iam/service_role?ref=0.0.2"
  name    = "rabbitmq"
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
  name    = "nexpose"
  service = "ec2"
}

resource "aws_iam_role_policy_attachment" "nexpose_scanning" {
  policy_arn = "${aws_iam_policy.nexpose_scanning.arn}"
  role       = "${module.nexpose_role.role_name}"
}
