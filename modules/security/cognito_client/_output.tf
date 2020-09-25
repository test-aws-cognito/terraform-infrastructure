output "COGNITO_USER_POOL_ARN" {
  value = tolist(data.aws_cognito_user_pools.application_user_pool.arns)[0]
}

output "COGNITO_USER_POOL_CLIENT_ID" {
  value = aws_cognito_user_pool_client.client.id
}

output "COGNITO_USER_POOL_CLIENT_SECRET" {
  value = aws_cognito_user_pool_client.client.client_secret
}

output "COGNITO_USER_POOL_ID" {
  value = tolist(data.aws_cognito_user_pools.application_user_pool.ids)[0]
}
