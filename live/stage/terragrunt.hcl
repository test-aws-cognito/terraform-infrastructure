terraform_version_constraint = ">= 0.14"

locals {
  global = yamldecode(file(find_in_parent_folders("terragrunt-config-global.yml")))
}

inputs = {
  REGION = "${local.global.aws.region}"
}

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
