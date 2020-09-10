data "aws_vpc" "terraform_vpc" {
  tags = {
    Name = var.VPC_NAME
  }
}

data "aws_subnet_ids" "terraform_public_subnets" {
  vpc_id = data.aws_vpc.terraform_vpc.id

  filter {
    name   = "tag:Name"
    values = ["${var.PUBLIC_SUBNET_NAME_PREFIX}*"]
  }
}

data "aws_subnet_ids" "terraform_private_subnets" {
  vpc_id = data.aws_vpc.terraform_vpc.id

  filter {
    name   = "tag:Name"
    values = ["${var.PRIVATE_SUBNET_NAME_PREFIX}*"]
  }
}
