module "cognito" {
  source = "../../../modules/security/cognito"

  TAG_PROJECT              = var.PROJECT_TAG
  COGNITO_USER_POOL_NAME   = var.COGNITO_USER_POOL_NAME
  COGNITO_USER_POOL_DOMAIN = var.COGNITO_APP_PARTIAL_DOMAIN
  COGNITO_USERS_MAIL       = var.COGITO_USERS_MAIL
}
