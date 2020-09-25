module "configuration" {
  source = "../../../configuration"
}

module "amis" {
  source = "../../../modules/amis"
}

module "vpc_data" {
  source = "../../../modules/network/vpc_data"

  PRIVATE_SUBNET_NAME_PREFIX = "${module.configuration.VPC_CONFIGURATION["vpc_name"]}-private"
  PUBLIC_SUBNET_NAME_PREFIX  = "${module.configuration.VPC_CONFIGURATION["vpc_name"]}-public"
  VPC_NAME                   = module.configuration.VPC_CONFIGURATION["vpc_name"]
}

module "postgresql" {
  source = "../../../modules/db/postgresql"

  EC2_IMAGE_ID             = module.amis.AMAZON_LINUX_2.image_id
  EC2_KEY_NAME             = module.configuration.EC2_KEY_NAME
  EC2_TYPE                 = module.configuration.EC2_FREE_TIER[module.configuration.REGION]
  POSTGRESQL_INSTANCE_NAME = module.configuration.POSTGRESQL["instance_name"]
  POSTGRESQL_PORT          = module.configuration.POSTGRESQL["port"]
  POSTGRESQL_PASSWORD      = module.configuration.POSTGRESQL["password"]
  VPC_ID                   = module.vpc_data.terraform_vpc.id
  SUBNET_ID                = tolist(module.vpc_data.terraform_subnets_ids_public.ids)[0]
}
