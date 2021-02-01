module "amis" {
  source = "../../../modules/amis"
}

module "vpc_data" {
  source = "../../../modules/network/vpc_data"

  PRIVATE_SUBNET_NAME_PREFIX = "${var.VPC_NAME}-private"
  PUBLIC_SUBNET_NAME_PREFIX  = "${var.VPC_NAME}-public"
  VPC_NAME                   = var.VPC_NAME
}

module "postgresql" {
  source = "../../../modules/db/postgresql"

  EC2_IMAGE_ID             = module.amis.AMAZON_LINUX_2.image_id
  EC2_KEY_NAME             = var.EC2_KEY_NAME
  EC2_TYPE                 = var.EC2_FREE_TIER_TYPE
  POSTGRESQL_INSTANCE_NAME = var.POSTGRESQL_INSTANCE_NAME
  POSTGRESQL_PORT          = var.POSTGRESQL_PORT
  POSTGRESQL_PASSWORD      = var.POSTGRESQL_PASSWORD
  VPC_ID                   = module.vpc_data.terraform_vpc.id
  SUBNET_ID                = tolist(module.vpc_data.terraform_subnets_ids_public.ids)[0]
}
