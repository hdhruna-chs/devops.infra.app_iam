output "default_api_task_role_arn" {
	  value = "${module.ecs_default_api_role.arn}"
}

output "correspondence_api_task_role_arn" {
	  value = "${module.ecs_correspondence_api_role.arn}"
}
output "logstash_instance_profile_id" {
  value = "${aws_iam_instance_profile.logstash_instance.id}"
}

output "rabbitmq_instance_profile_id" {
	value = "${aws_iam_instance_profile.rabbitmq.id}"
}

output "nexpose_instance_profile_id" {
	value = "${aws_iam_instance_profile.nexpose_scanner.id}"
}

output "vault_server_instance_profile_id" {
  value = "${aws_iam_instance_profile.vault_server.id}"
}

output "mule_server_instance_profile_id" {
  value = "${aws_iam_instance_profile.mule_server.id}"
}
