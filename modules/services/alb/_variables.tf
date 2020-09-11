variable "TAG_PROJECT" {
  type = string
}

variable "VPC_ID" {
  type = string
}

variable "VPC_PUBLIC_SUBNETS_IDS" {
  type = list(string)
}

variable "SSL_CERTIFICATE_DOMAIN_NAME" {
  type = string
}

variable "ALB_NAME" {
  type = string
}
