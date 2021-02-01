variable "PROJECT_TAG" {
  type = string
}

variable "REGION" {
  type = string
}

variable "ELASTICACHE_FREE_TIER" {
  type = string
}

variable "EC2_KEY_NAME" {
  type = string
}

variable "EC2_FREE_TIER_TYPE" {
  type = string
}

variable "BASTION_HOST_FLAG" {
  type = number
}

variable "LOAD_BALANCER_LISTENER_PATH" {
  type = string

  default = "/*"
}

variable "VPC_NAME" {
  type = string
}

variable "ALB_NAME" {
  type = string
}

variable "COGNITO_USER_POOL_NAME" {
  type = string
}

variable "COGNITO_APP_PARTIAL_DOMAIN" {
  type = string
}

variable "POSTGRESQL_INSTANCE_NAME" {
  type = string
}

variable "POSTGRESQL_PORT" {
  type = string
}

variable "POSTGRESQL_DB" {
  type = string
}

variable "POSTGRESQL_USER" {
  type = string
}

variable "POSTGRESQL_PASSWORD" {
  type = string
}
