resource "aws_cognito_user_group" "app_admin" {
  name         = "app_admin"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_group" "app_user" {
  name         = "app_user"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

data "template_file" "application_bootstrap" {
  template = file("${path.module}/resources/create_users.json")

  vars = {
    user_pool_id          = aws_cognito_user_pool.user_pool.id
    users_mail            = var.COGNITO_USERS_MAIL
    user_pool_group_admin = aws_cognito_user_group.app_admin.name
    user_pool_group_user  = aws_cognito_user_group.app_user.name
  }
}

resource "aws_cloudformation_stack" "test_users" {
  name = "${var.TAG_PROJECT}-test-users"

  template_body = data.template_file.application_bootstrap.rendered
}
