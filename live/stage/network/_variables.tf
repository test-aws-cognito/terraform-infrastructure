variable "PROJECT_TAG" {
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
