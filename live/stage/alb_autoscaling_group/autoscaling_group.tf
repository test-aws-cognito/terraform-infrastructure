resource "aws_launch_configuration" "application_template" {
  image_id      = module.amis.AMAZON_LINUX_2.image_id
  instance_type = module.configuration.EC2_FREE_TIER[module.configuration.REGION]

  key_name = module.keys.PR_KEY_01.key_name

  security_groups = [aws_security_group.autoscaling_group.id]

  user_data = file("${path.module}/resources/bootstrap.sh")
}

resource "aws_autoscaling_group" "application" {

  name = "terraform-autoscaling-group"

  min_size         = 1
  desired_capacity = 1
  max_size         = 1

  launch_configuration = aws_launch_configuration.application_template.name

  vpc_zone_identifier = module.vpc_data.terraform_subnets_ids_public.ids
}
