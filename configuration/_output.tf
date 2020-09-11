////////////////////////////////////////////////////////////////////////////////
// PROJECT
////////////////////////////////////////////////////////////////////////////////
output "TAG_PROJECT" {
  value = var.TAG_PROJECT
}

////////////////////////////////////////////////////////////////////////////////
// AWS CONNECTION
////////////////////////////////////////////////////////////////////////////////
output "REGION" {
  value = var.REGION
}

output "CREDENTIALS_FILE" {
  value = "%USERPROFILE%/.aws/credentials"
}

output "CREDENTIALS_PROFILE" {
  value = "default"
}

////////////////////////////////////////////////////////////////////////////////
// AWS DATA
////////////////////////////////////////////////////////////////////////////////
output "EC2_FREE_TIER" {
  value = {
    "eu-central-1" : "t2.micro",
    "eu-west-3" : "t2.micro",
    "eu-north-1" : "t3.micro",
  }
}

////////////////////////////////////////////////////////////////////////////////
// APPLICATION
////////////////////////////////////////////////////////////////////////////////
output "SSL_CERTIFICATE_DOMAIN_NAME" {
  value = "*.amazonaws.com"
}

output "VPC_CONFIGURATION" {
  value = {
    vpc_name               = "terraform-cognito-vpc"
    vpc_cidr               = "10.0.0.0/16"
    vpc_availability_zones = ["${var.REGION}a", "${var.REGION}b", "${var.REGION}c"]

    private_subnet_name_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
    public_subnet_name_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }
}

output "ALB_NAME" {
  value = "${var.TAG_PROJECT}-alb"
}

output "COGNITO" {
  value = {
    user_pool_name  = "test-user-pool"
    app_client_id   = "51ljjpi2gpulufuk4g0e9ra9v5"
    app_domain_name = "kotu.auth.eu-central-1.amazoncognito.com"
  }
}
