# Providers

provider "aws" {
  region  = data.terraform_remote_state.config.outputs.default_region
  profile = data.terraform_remote_state.config.outputs.run_env
}

# Backend

terraform {
  required_version = ">=0.11.0"

  backend "s3" {
    bucket = "cv-terraform-backend"
    key    = "app_iam/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table       = "cv-terraform-state"
    workspace_key_prefix = "terraform-state"
  }
}

### Terraform linked projects ###

data "terraform_remote_state" "config" {
  backend = "s3"
  config = {
    bucket = "cv-terraform-backend"
    key    = "terraform-state/${var.workspace}/config/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "buckets" {
  backend = "s3"
  config = {
    bucket = "cv-terraform-backend"
    key    = "terraform-state/${var.workspace}/buckets/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "cv-terraform-backend"
    key    = "terraform-state/${var.workspace}/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "cognito" {
  backend = "remote"
  config = {
    organization = "corvesta"
    workspaces = {
      name = "devops-infra-cognito-${var.workspace}"
    }
  }
}

