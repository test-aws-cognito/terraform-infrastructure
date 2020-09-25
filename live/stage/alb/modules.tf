module "configuration" {
  source = "../../../configuration"
}

module "vpc_data" {
  source = "../../../modules/network/vpc_data"

  PRIVATE_SUBNET_NAME_PREFIX = "${module.configuration.VPC_CONFIGURATION["vpc_name"]}-private"
  PUBLIC_SUBNET_NAME_PREFIX  = "${module.configuration.VPC_CONFIGURATION["vpc_name"]}-public"
  VPC_NAME                   = module.configuration.VPC_CONFIGURATION["vpc_name"]
}

module "alb" {
  source = "../../../modules/services/alb"

  SSL_CERTIFICATE_DOMAIN_NAME = module.configuration.SSL_CERTIFICATE_DOMAIN_NAME
  TAG_PROJECT                 = module.configuration.TAG_PROJECT
  VPC_ID                      = module.vpc_data.terraform_vpc.id
  VPC_PUBLIC_SUBNETS_IDS      = module.vpc_data.terraform_subnets_ids_public.ids
  ALB_NAME                    = module.configuration.ALB_NAME
}
