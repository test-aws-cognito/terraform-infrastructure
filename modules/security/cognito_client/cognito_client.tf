data "aws_cognito_user_pools" "application_user_pool" {
  name = var.COGNITO_USER_POOL_NAME
}

variable "COGNITO_ALLOWED_CALLBACK_URLS" {
  type = list(string)
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.TAG_PROJECT}-alb-client"

  user_pool_id = tolist(data.aws_cognito_user_pools.application_user_pool.ids)[0]


  supported_identity_providers         = ["COGNITO"]
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]

  callback_urls = var.COGNITO_ALLOWED_CALLBACK_URLS
}
