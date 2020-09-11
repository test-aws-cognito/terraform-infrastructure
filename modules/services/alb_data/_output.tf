output "ALB" {
  value = data.aws_lb.selected
}

output "ALB_LISTENER" {
  value = data.aws_lb_listener.selected
}
