module "configuration" {
  source = "../../../configuration"
}

module "cognito" {
  source = "../../../modules/security/cognito"

  TAG_PROJECT              = module.configuration.TAG_PROJECT
  COGNITO_USER_POOL_NAME   = module.configuration.COGNITO["user_pool_name"]
  COGNITO_USER_POOL_DOMAIN = module.configuration.COGNITO["app_partial_domain"]
  COGNITO_USERS_MAIL       = var.COGITO_USERS_MAIL
}
