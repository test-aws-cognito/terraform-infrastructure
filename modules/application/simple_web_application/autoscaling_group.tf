data "template_file" "application_bootstrap" {
  template = file("${path.module}/resources/bootstrap.sh")

  vars = {
    cognito_aws_region        = var.COGNITO_REGION
    cognito_user_pool_id      = var.COGNITO_USER_POOL_ID
    cognito_client_id         = var.COGNITO_USER_POOL_CLIENT_ID
    cognito_client_secret     = var.COGNITO_USER_POOL_CLIENT_SECRET
    cogito_login_redirect_uri = var.COGNITO_LOGIN_REDIRECT_URI
    redis_hostname            = var.REDIS_HOST
    redis_port                = var.REDIS_PORT
    postgresql_hostname       = var.POSTGRESQL_HOSTNAME
    postgresql_port           = var.POSTGRESQL_PORT
    postgresql_db             = var.POSTGRESQL_DB
    postgresql_user           = var.POSTGRESQL_USER
    postgresql_password       = var.POSTGRESQL_PASSWORD
  }
}

resource "aws_launch_configuration" "application_template" {
  image_id      = var.EC2_IMAGE_ID
  instance_type = var.EC2_TYPE

  key_name = var.EC2_KEY_NAME

  security_groups = [var.ASG_SECURITY_GROUP_ID]

  user_data = data.template_file.application_bootstrap.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "autoscaling_target_group" {
  name     = "${var.TAG_PROJECT}-asg-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.VPC_ID

  health_check {
    protocol            = "HTTPS"
    port                = "443"
    path                = "/healthcheck.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 90
    timeout             = 20
  }
}

resource "aws_autoscaling_group" "application" {
  depends_on = [var.REDIS_DEPENDENCY]

  name = "terraform-autoscaling-group"

  min_size         = var.ASG_MIN_SIZE
  desired_capacity = var.ASG_DESIRED_SIZE
  max_size         = var.ASG_MAX_SIZE

  launch_configuration      = aws_launch_configuration.application_template.name
  vpc_zone_identifier       = var.VPC_SUBNETS_IDS
  health_check_type         = "ELB"
  health_check_grace_period = "90"
  target_group_arns         = [aws_lb_target_group.autoscaling_target_group.arn]
}
