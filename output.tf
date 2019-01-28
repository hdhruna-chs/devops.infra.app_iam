output "default_api_task_role_arn" {
	  value = "${module.ecs_default_api_role.arn}"
}
output "default_lambda_role" {
	value = "${module.default_lambda_role.arn}"
}
output "consul_lambda_role" {
	value = "${module.consul_lambda_role.arn}"
}

output "s3_trigger_lambda_role" {
	value = "${module.s3_trigger_lambda_role.arn}"
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

output "nomad_server_instance_profile_id" {
  value = "${aws_iam_instance_profile.nomad_server.id}"
}

output "claims_input_bucket_role" {
  value = "${module.claims_input_bucket_role.arn}"
}
