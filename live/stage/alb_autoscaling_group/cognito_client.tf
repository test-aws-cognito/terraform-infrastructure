data "aws_cognito_user_pools" "application_user_pool" {
  name = module.configuration.COGNITO["user_pool_name"]
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${module.configuration.TAG_PROJECT}-alb-client"

  user_pool_id = tolist(data.aws_cognito_user_pools.application_user_pool.ids)[0]


  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = ["https://${module.alb_data.ALB.dns_name}/oauth2/idpresponse"]
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
}
