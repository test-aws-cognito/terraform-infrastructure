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

module "alb_data" {
  source = "../../../modules/services/alb_data"

  ALB_NAME = module.configuration.ALB_NAME
}

module "postgresql" {
  source = "../../../modules/db/postgresql_data"

  INSTANCE_NAME = module.configuration.POSTGRESQL["instance_name"]
}

//module "alb_data" {
//  source = "../../../modules/services/alb_data_mock"
//
//  ALB_NAME = module.configuration.ALB_NAME
//}

module "cognito_client" {
  source = "../../../modules/security/cognito_client"

  COGNITO_USER_POOL_NAME = module.configuration.COGNITO["user_pool_name"]
  TAG_PROJECT            = module.configuration.TAG_PROJECT

  COGNITO_ALLOWED_CALLBACK_URLS = [
    "https://${module.alb_data.ALB.dns_name}/oauth2/idpresponse",
    "https://${module.alb_data.ALB.dns_name}:443/login/oauth2/code/cognito"
  ]
}

module "ec2_web_security_group" {
  source = "../../../modules/security/ec2_web_security_group"

  VPC_ID = module.vpc_data.terraform_vpc.id
}

module "redis" {
  source = "../../../modules/db/redis"

  ALLOWED_SECURITY_GROUPS_IDS = [module.ec2_web_security_group.SECURITY_GROUP_ID]
  ALLOWED_SUBNET_IDS          = setunion(module.vpc_data.terraform_subnets_ids_public.ids, module.vpc_data.terraform_subnets_ids_private.ids)
  NODE_TYPE                   = module.configuration.ELASTICACHE_FREE_TIER[module.configuration.REGION]
  TAG_PROJECT                 = module.configuration.REGION
}

module "application_autoscaling_group" {
  source = "../../../modules/application/simple_web_application"

  TAG_PROJECT = module.configuration.TAG_PROJECT

  EC2_IMAGE_ID = module.amis.AMAZON_LINUX_2.image_id
  EC2_KEY_NAME = module.configuration.EC2_KEY_NAME
  EC2_TYPE     = module.configuration.EC2_FREE_TIER[module.configuration.REGION]

  VPC_ID          = module.vpc_data.terraform_vpc.id
  VPC_SUBNETS_IDS = module.vpc_data.terraform_subnets_ids_public.ids

  ASG_MIN_SIZE          = 1
  ASG_DESIRED_SIZE      = 2
  ASG_MAX_SIZE          = 2
  ASG_SECURITY_GROUP_ID = module.ec2_web_security_group.SECURITY_GROUP_ID

  COGNITO_LOGIN_REDIRECT_URI      = "https://${module.alb_data.ALB.dns_name}:${module.alb_data.ALB_LISTENER.port}/login/oauth2/code/cognito"
  COGNITO_REGION                  = module.configuration.COGNITO["region"]
  COGNITO_USER_POOL_CLIENT_ID     = module.cognito_client.COGNITO_USER_POOL_CLIENT_ID
  COGNITO_USER_POOL_CLIENT_SECRET = module.cognito_client.COGNITO_USER_POOL_CLIENT_SECRET
  COGNITO_USER_POOL_ID            = module.cognito_client.COGNITO_USER_POOL_ID

  REDIS_DEPENDENCY = module.redis
  REDIS_HOST       = module.redis.HOST
  REDIS_PORT       = module.redis.PORT

  POSTGRESQL_HOSTNAME = module.postgresql.INSTANCE.public_ip
  POSTGRESQL_PORT     = module.configuration.POSTGRESQL["port"]
  POSTGRESQL_DB       = module.configuration.POSTGRESQL["db"]
  POSTGRESQL_USER     = module.configuration.POSTGRESQL["user"]
  POSTGRESQL_PASSWORD = module.configuration.POSTGRESQL["password"]
}

module "alb_plugin" {
  source = "../../../modules/services/alb_plugin"

  ALB_LISTENER_ARN            = module.alb_data.ALB_LISTENER.arn
  ALB_TARGET_GROUP            = module.application_autoscaling_group.AUTOSCALING_TARGET_GROUP_ARN
  COGNITO_USER_POOL_ARN       = module.cognito_client.COGNITO_USER_POOL_ARN
  COGNITO_USER_POOL_CLIENT_ID = module.cognito_client.COGNITO_USER_POOL_CLIENT_ID
  COGNITO_USER_POOL_DOMAIN    = module.configuration.COGNITO["app_domain_name"]
  LOAD_BALANCER_LISTENER_PATH = var.LOAD_BALANCER_LISTENER_PATH
}

//module "bastion_host" {
//  source = "../../../modules/services/bastion_host"
//
//  AMI       = module.amis.AMAZON_LINUX_2.image_id
//  EC2_TYPE  = module.configuration.EC2_FREE_TIER[module.configuration.REGION]
//  KEY_NAME  = module.keys.PR_KEY_01.key_name
//  SUBNET_ID = tolist(module.vpc_data.terraform_subnets_ids_public.ids)[0]
//  VPC_ID    = module.vpc_data.terraform_vpc.id
//}
