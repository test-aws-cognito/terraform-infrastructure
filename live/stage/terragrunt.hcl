// `inputs` block is at the end of this file

////////////////////////////////////////////////////////////////////////////////
// LOCALS
////////////////////////////////////////////////////////////////////////////////
locals {
  global = yamldecode(file(find_in_parent_folders("terragrunt-config-global.yml")))
}

////////////////////////////////////////////////////////////////////////////////
// REMOTE_STATE
////////////////////////////////////////////////////////////////////////////////
remote_state {
  backend = "s3"

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket = "${local.global.terraform.backend.prefix}-bucket"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.global.aws.region}"
    encrypt = true
    dynamodb_table = "${local.global.terraform.backend.prefix}-table"
  }
}

////////////////////////////////////////////////////////////////////////////////
// PROVIDER
////////////////////////////////////////////////////////////////////////////////
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region                  = "${local.global.aws.region}"
  shared_credentials_file = "${local.global.aws.credentials.file}"
  profile                 = "${local.global.aws.credentials.profile}"
}
EOF
}

////////////////////////////////////////////////////////////////////////////////
// INPUTS
////////////////////////////////////////////////////////////////////////////////
// Inputs passed to terraform are preconfigured with Terragrunt variables.
// Usually modification of following block should not be necessary.
inputs = {
  REGION = "${local.global.aws.region}"

  PROJECT_TAG = "${local.global.project_name}"

  BASTION_HOST_FLAG = "${local.global.bastion_host_flag}"

  VPC_NAME = "terraform-cognito-vpc"
  VPC_CIDR = "10.0.0.0/16"
  VPC_AVAILABILITY_ZONES = ["${local.global.aws.region}a", "${local.global.aws.region}b", "${local.global.aws.region}c"]
  VPC_PRIVATE_SUBNET_NAME_CIDRS = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  VPC_PUBLIC_SUBNET_NAME_CIDRS = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  EC2_KEY_NAME = "pr-01-key"
  EC2_FREE_TIER_TYPE = "t2.micro"

  ELASTICACHE_FREE_TIER = "cache.t2.micro"

  POSTGRESQL_INSTANCE_NAME = "${local.global.project_name}-postgresql"
  POSTGRESQL_PORT = 5432
  POSTGRESQL_DB = "postgres"
  POSTGRESQL_USER = "postgres"
  # Do not try this at home ;)
  POSTGRESQL_PASSWORD = "pass"

  COGNITO_USER_POOL_NAME = "${local.global.project_name}-user-pool"
  # Cannot contain `cognito` word as it is reserver word
  COGNITO_APP_PARTIAL_DOMAIN = "gft-domain"
  COGITO_USERS_MAIL = "${local.global.cognito.mail}"

  SSL_CERTIFICATE_DOMAIN_NAME = "*.amazonaws.com"
  ALB_NAME = "${local.global.project_name}-alb"
}
