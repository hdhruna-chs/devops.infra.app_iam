#Nomad
resource "aws_iam_role_policy_attachment" "nomad_s3_access" {
  role       = module.ec2_nomad_role.role_name
  policy_arn = aws_iam_policy.nomad_s3_access_policy.arn
}

resource "aws_iam_policy" "nomad_s3_access_policy" {
  name   = "${data.terraform_remote_state.config.outputs.run_env}.default-nomad-s3-access"
  policy = data.template_file.nomad_s3_access.rendered

}

data "template_file" "nomad_s3_access" {
  template = file("${path.module}/policies/read_write_all_s3_with_deny.json.tpl")
}
