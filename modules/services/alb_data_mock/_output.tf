variable "ALB" {
  default = {
    dns_name = "foo-bar-host"
  }
}

output "ALB" {
  value = var.ALB
}

variable "ALB_LISTENER" {
  default = {
    port = 443,
  }
}

output "ALB_LISTENER" {
  value = var.ALB_LISTENER
}
