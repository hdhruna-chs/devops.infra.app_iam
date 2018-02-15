resource "aws_iam_instance_profile" "logstash_instance" {
  name = "logstash-instance"
  role = "${module.ec2_logstash_role.role_name}"
}

resource "aws_iam_instance_profile" "rabbitmq" {
  name = "rabbitmq"
  role = "${module.rabbitmq_role.role_name}"
}

resource "aws_iam_instance_profile" "nexpose_scanner" {
  name = "nexpose_scanner"
  role = "${module.nexpose_role.role_name}"
}
