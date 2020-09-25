resource "aws_security_group" "application_load_balancer" {
  name = "${var.TAG_PROJECT}-alb-sg"

  vpc_id = var.VPC_ID

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.TAG_PROJECT
  }
}

resource "aws_lb" "application_load_balancer" {
  name               = var.ALB_NAME
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.application_load_balancer.id]
  subnets            = var.VPC_PUBLIC_SUBNETS_IDS

  tags = {
    Project = var.TAG_PROJECT
  }
}

data "aws_acm_certificate" "application_certificate" {
  domain = var.SSL_CERTIFICATE_DOMAIN_NAME
}

resource "aws_lb_listener" "application_load_balancer_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.application_certificate.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener" "alb_listener_80_redirect" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
