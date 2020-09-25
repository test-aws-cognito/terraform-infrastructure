terraform {
  backend "s3" {
    # General settings
    region  = "eu-central-1"
    encrypt = true

    # S3 state bucket
    bucket = "kotu-terraform-bucket-2020-09-09"
    key    = "project-raisin-cognito/live/stage/postgresql/terraform.tfstate"

    # DynamoDB locking table
    dynamodb_table = "kotu-terraform-table"
  }
}
