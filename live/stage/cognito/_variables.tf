variable "COGITO_USERS_MAIL" {
  type = string

  description = "On this mail passwords for example users will be sent. It is only method I know for receiving password after automatic user creation."
}

variable "PROJECT_TAG" {
  type = string
}

variable "COGNITO_USER_POOL_NAME" {
  type = string
}

variable "COGNITO_APP_PARTIAL_DOMAIN" {
  type = string
}
