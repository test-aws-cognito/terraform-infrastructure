module "configuration" {
  source = "../../../configuration"
}

module "amis" {
  source = "../../../modules/amis"
}

module "keys" {
  source = "../../../modules/authorization/keys"
}

module "vpc_data" {
  source = "../../../modules/network/vpc_data"

  PRIVATE_SUBNET_NAME_PREFIX = "${module.configuration.VPC_CONFIGURATION["vpc_name"]}-private"
  PUBLIC_SUBNET_NAME_PREFIX = "${module.configuration.VPC_CONFIGURATION["vpc_name"]}-public"
  VPC_NAME = module.configuration.VPC_CONFIGURATION["vpc_name"]
}

module "bastion_host" {
  source = "../../../modules/services/bastion_host"

  AMI       = module.amis.AMAZON_LINUX_2.image_id
  EC2_TYPE  = module.configuration.EC2_FREE_TIER[module.configuration.REGION]
  KEY_NAME  = module.keys.PR_KEY_01.key_name
  SUBNET_ID = tolist(module.vpc_data.terraform_subnets_ids_public.ids)[0]
  VPC_ID    = module.vpc_data.terraform_vpc.id
}
