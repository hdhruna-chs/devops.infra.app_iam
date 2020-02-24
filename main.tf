provider "aws" {
  region  = data.terraform_remote_state.config.outputs.default_region
  profile = local.workspace
}

terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "cchs-terraform-backend"
    key    = "terraform.tfstate"

    dynamodb_table       = "terraform-state"
    workspace_key_prefix = "terraform-state/app_iam"
  }
}

data "terraform_remote_state" "config" {
  backend = "s3"

  config = {
    bucket = "cchs-terraform-backend"
    key    = "terraform-state/config/${local.workspace}/terraform.tfstate"   
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "cchs-terraform-backend"
    key    = "terraform-state/vpc/${local.workspace}/terraform.tfstate"   
    region = "us-east-1"
  }
}

data "terraform_remote_state" "database" {
  backend = "s3"

  config = {
    bucket = "cchs-terraform-backend"
    key    = "terraform-state/rds-postgresql/${local.workspace}/terraform.tfstate"   
    region = "us-east-1"
  }
}