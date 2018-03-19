resource "aws_iam_instance_profile" "rabbitmq" {
  name = "rabbitmq"
  role = "${module.rabbitmq_role.role_name}"
}
