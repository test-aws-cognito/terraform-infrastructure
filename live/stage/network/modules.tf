module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.VPC_NAME
  cidr = var.VPC_CIDR

  azs             = var.VPC_AVAILABILITY_ZONES
  private_subnets = var.VPC_PRIVATE_SUBNET_NAME_CIDRS
  public_subnets  = var.VPC_PUBLIC_SUBNET_NAME_CIDRS

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = {
    Project   = var.PROJECT_TAG
    Terraform = "true"
  }
}
