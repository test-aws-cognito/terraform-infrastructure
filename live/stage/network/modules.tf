module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.VPC_NAME
  cidr = var.VPC_CIDR

  azs             = var.VPC_AVAILABILITY_ZONES
  private_subnets = var.VPC_PRIVATE_SUBNET_NAME_CIDRS
  public_subnets  = var.VPC_PUBLIC_SUBNET_NAME_CIDRS

  tags = {
    Project   = var.PROJECT_TAG
    Terraform = "true"
  }
}
