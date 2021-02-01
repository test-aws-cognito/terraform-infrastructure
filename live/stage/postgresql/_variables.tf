variable "EC2_KEY_NAME" {
  type = string
}

variable "VPC_NAME" {
  type = string
}

variable "VPC_CIDR" {
  type = string
}

variable "VPC_AVAILABILITY_ZONES" {
  type = list(string)
}

variable "VPC_PRIVATE_SUBNET_NAME_CIDRS" {
  type = list(string)
}

variable "VPC_PUBLIC_SUBNET_NAME_CIDRS" {
  type = list(string)
}

variable "EC2_FREE_TIER_TYPE" {
  type = string
}

variable "POSTGRESQL_INSTANCE_NAME" {
  type = string
}

variable "POSTGRESQL_PORT" {
  type = string
}

variable "POSTGRESQL_PASSWORD" {
  type = string
}
