resource "aws_lb_listener_rule" "autoscaling_alb_lr" {

  listener_arn = var.ALB_LISTENER_ARN
  priority     = 50000

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = var.COGNITO_USER_POOL_ARN
      user_pool_client_id = var.COGNITO_USER_POOL_CLIENT_ID
      user_pool_domain    = var.COGNITO_USER_POOL_DOMAIN
    }
  }

  action {
    type             = "forward"
    target_group_arn = var.ALB_TARGET_GROUP
  }

  condition {
    //noinspection HCLUnknownBlockType
    path_pattern {
      values = [var.LOAD_BALANCER_LISTENER_PATH]
    }
  }
}
