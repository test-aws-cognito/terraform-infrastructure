data "aws_lb" "selected" {
  name = var.ALB_NAME
}

data "aws_lb_listener" "selected" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = var.LISTENER_PORT
}
