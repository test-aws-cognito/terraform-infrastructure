resource "aws_security_group" "autoscaling_group" {
  name = "terraform-security-group"

  vpc_id = module.vpc_data.terraform_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    //    security_groups = [var.LOAD_BALANCER_SECURITY_GROUP_ID]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "application_template" {
  image_id      = module.amis.AMAZON_LINUX_2.image_id
  instance_type = module.configuration.EC2_FREE_TIER[module.configuration.REGION]

  key_name = module.keys.PR_KEY_01.key_name

  security_groups = [aws_security_group.autoscaling_group.id]

  user_data = file("${path.module}/resources/bootstrap.sh")
}

resource "aws_autoscaling_group" "application" {

  name = "terraform-autoscaling-group"

  min_size         = 2
  desired_capacity = 2
  max_size         = 2

  launch_configuration      = aws_launch_configuration.application_template.name
  vpc_zone_identifier       = module.vpc_data.terraform_subnets_ids_public.ids
  health_check_type         = "ELB"
  health_check_grace_period = "300"
  target_group_arns         = [aws_lb_target_group.autoscaling_target_group.arn]
}
