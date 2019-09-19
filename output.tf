output "default_api_task_role_arn" {
  value = module.ecs_default_api_role.arn
}

output "default_lambda_role" {
  value = module.default_lambda_role.arn
}

output "consul_lambda_role" {
  value = module.consul_lambda_role.arn
}

output "aws_config_role" {
  value = module.aws_config_role.arn
}

output "s3_trigger_lambda_role" {
  value = module.s3_trigger_lambda_role.arn
}

output "s3_trigger_lambda_claims_role" {
  value = module.s3_trigger_lambda_claims_role.arn
}


output "authorizer_lambda_role" {
  value = module.authorizer_lambda_role.arn
}

output "correspondence_api_task_role_arn" {
  value = module.ecs_correspondence_api_role.arn
}

output "finance_api_task_role_arn" {
  value = module.ecs_finance_api_role.arn
}

output "user_management_api_task_role_arn" {
  value = module.ecs_user_management_api_role.arn
}

output "logstash_instance_profile_id" {
  value = aws_iam_instance_profile.logstash_instance.id
}

output "rabbitmq_instance_profile_id" {
  value = aws_iam_instance_profile.rabbitmq.id
}

output "nexpose_instance_profile_id" {
  value = aws_iam_instance_profile.nexpose_scanner.id
}

output "alfresco_instance_profile_id" {
  value = aws_iam_instance_profile.alfresco.id
}

output "vault_server_instance_profile_id" {
  value = aws_iam_instance_profile.vault_server.id
}

output "mule_server_instance_profile_id" {
  value = aws_iam_instance_profile.mule_server.id
}

output "nomad_server_instance_profile_id" {
  value = aws_iam_instance_profile.nomad_server.id
}

output "ice_bucket_role" {
  value = module.ice_bucket_role.arn
}

output "claims_bucket_role" {
  value = module.claims_bucket_role.arn
}

output "nginx_nlb_update_role" {
  value = module.nginx_nlb_update_role.arn
}

output "backup_ec2_n_delete_ami_role" {
  value = module.backup_ec2_n_delete_ami_role.arn
}

output "s3presigned_task_role_arn" {
  value = module.ecs_s3presign_api_role.arn
}

output "ecs_user_management_api_role" {
  value = module.ecs_user_management_api_role.arn
}

output "ecs_claims_api_role" {
  value = module.ecs_claims_api_role.arn
}

output "airflow_role" {
  value = module.airflow_role
}

output "external_dns_role" {
  value = module.external_dns_role
}

output "server_node" {
  value = aws_iam_role_policy.server_node.name
}

output "kiam_server_role" {
  value = aws_iam_role.server_role
}
