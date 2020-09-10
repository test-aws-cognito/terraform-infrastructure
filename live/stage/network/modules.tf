module "configuration" {
  source = "../../../configuration"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = module.configuration.VPC_CONFIGURATION["vpc_name"]
  cidr = module.configuration.VPC_CONFIGURATION["vpc_cidr"]

  azs             = module.configuration.VPC_CONFIGURATION["vpc_availability_zones"]
  private_subnets = module.configuration.VPC_CONFIGURATION["private_subnet_name_cidrs"]
  public_subnets  = module.configuration.VPC_CONFIGURATION["public_subnet_name_cidrs"]

  tags = {
    Project   = module.configuration.TAG_PROJECT
    Terraform = "true"
  }
}
