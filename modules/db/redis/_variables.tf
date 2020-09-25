variable "TAG_PROJECT" {
  type = string
}

variable "NODE_TYPE" {
  type = string
}

variable "ALLOWED_SECURITY_GROUPS_IDS" {
  type = list(string)
}

variable "ALLOWED_SUBNET_IDS" {
  type = list(string)
}
