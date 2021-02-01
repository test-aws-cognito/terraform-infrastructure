module "vpc_data" {
  source = "../../../modules/network/vpc_data"

  PRIVATE_SUBNET_NAME_PREFIX = "${var.VPC_NAME}-private"
  PUBLIC_SUBNET_NAME_PREFIX  = "${var.VPC_NAME}-public"
  VPC_NAME                   = var.VPC_NAME
}

module "alb" {
  source = "../../../modules/services/alb"

  SSL_CERTIFICATE_DOMAIN_NAME = var.SSL_CERTIFICATE_DOMAIN_NAME
  TAG_PROJECT                 = var.PROJECT_TAG
  VPC_ID                      = module.vpc_data.terraform_vpc.id
  VPC_PUBLIC_SUBNETS_IDS      = module.vpc_data.terraform_subnets_ids_public.ids
  ALB_NAME                    = var.ALB_NAME
}
