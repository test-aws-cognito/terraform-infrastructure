resource "aws_cognito_user_pool" "user_pool" {
  name = var.COGNITO_USER_POOL_NAME

  password_policy {
    minimum_length                   = 6
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = var.COGNITO_USER_POOL_DOMAIN
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
