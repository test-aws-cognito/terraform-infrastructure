resource "aws_security_group" "application_load_balancer" {
  name = "${module.configuration.TAG_PROJECT}-alb-sg"

  vpc_id = module.vpc_data.terraform_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "autoscaling_alb" {
  name               = "${module.configuration.TAG_PROJECT}-asg-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.application_load_balancer.id]
  subnets            = module.vpc_data.terraform_subnets_ids_public.ids

  tags = {
    Project = module.configuration.TAG_PROJECT
  }
}

resource "aws_lb_listener" "autoscaling_alb_listener" {
  load_balancer_arn = aws_lb.autoscaling_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}
