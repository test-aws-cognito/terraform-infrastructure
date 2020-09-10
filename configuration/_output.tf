output "REGION" {
  value = var.REGION
}

output "CREDENTIALS_FILE" {
  value = "%USERPROFILE%/.aws/credentials"
}

output "CREDENTIALS_PROFILE" {
  value = "default"
}

output "EC2_FREE_TIER" {
  value = {
    "eu-central-1" : "t2.micro",
    "eu-west-3" : "t2.micro",
    "eu-north-1" : "t3.micro",
  }
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
