data "aws_cognito_user_pools" "application_user_pool" {
  name = module.configuration.COGNITO["user_pool_name"]
}

resource "aws_lb_target_group" "autoscaling_target_group" {
  name     = "${module.configuration.TAG_PROJECT}-asg-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc_data.terraform_vpc.id

  health_check {
    protocol            = "HTTP"
    port                = "80"
    path                = "/index.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 300
    timeout             = 20
  }
}

resource "aws_lb_listener_rule" "autoscaling_alb_lr" {

  listener_arn = module.alb_data.ALB_LISTENER.arn
  priority     = 50000

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = tolist(data.aws_cognito_user_pools.application_user_pool.arns)[0]
      user_pool_client_id = module.configuration.COGNITO["app_client_id"]
      user_pool_domain    = module.configuration.COGNITO["app_domain_name"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.autoscaling_target_group.arn
  }

  condition {
    //noinspection HCLUnknownBlockType
    path_pattern {
      values = [var.LOAD_BALANCER_LISTENER_PATH]
    }
  }
}
