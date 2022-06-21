data "aws_vpc" "terraform_vpc" {
  tags = {
    Name = var.VPC_NAME
  }
}

data "aws_subnets" "terraform_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.terraform_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.PUBLIC_SUBNET_NAME_PREFIX}*"]
  }
}

data "aws_subnets" "terraform_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.terraform_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.PRIVATE_SUBNET_NAME_PREFIX}*"]
  }
}
