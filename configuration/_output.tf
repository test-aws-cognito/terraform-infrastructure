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

////////////////////////////////////////////////////////////////////////////////
// AWS DATA
////////////////////////////////////////////////////////////////////////////////
output "EC2_FREE_TIER" {
  value = {
    "eu-central-1" = "t2.micro",
    "eu-west-3"    = "t2.micro",
    "eu-north-1"   = "t3.micro",
  }
}

output "ELASTICACHE_FREE_TIER" {
  value = {
    "eu-central-1" = "cache.t2.micro",
  }
}

////////////////////////////////////////////////////////////////////////////////
// APPLICATION
////////////////////////////////////////////////////////////////////////////////
output "SSL_CERTIFICATE_DOMAIN_NAME" {
  value = "*.amazonaws.com"
}

output "EC2_KEY_NAME" {
  value = "pr-01-key"
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
    region             = var.REGION
    user_pool_name     = "${var.TAG_PROJECT}-user-pool"
    app_partial_domain = var.COGNITO_PARTIAL_DOMAIN
    app_domain_name    = "${var.COGNITO_PARTIAL_DOMAIN}.auth.eu-central-1.amazoncognito.com"
  }
}

output "POSTGRESQL" {
  value = {
    instance_name = "${var.TAG_PROJECT}-postgresql"
    db            = "postgres"
    port          = 5432
    user          = "postgres"
    # Do not try this at home!
    password = "pass"
  }
}
