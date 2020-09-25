resource "aws_security_group" "postgres_sg" {
  name = "terraform-security-group"

  vpc_id = var.VPC_ID

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP"
    from_port   = 5432
    to_port     = 5432
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

data "template_file" "application_bootstrap" {
  template = file("${path.module}/resources/bootstrap.sh")
  vars = {
    port = var.POSTGRESQL_PORT
    pass = var.POSTGRESQL_PASSWORD
  }
}

resource "aws_instance" "web" {
  ami           = var.EC2_IMAGE_ID
  instance_type = var.EC2_TYPE

  key_name = var.EC2_KEY_NAME

  subnet_id              = var.SUBNET_ID
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  user_data = data.template_file.application_bootstrap.rendered

  tags = {
    Name = var.POSTGRESQL_INSTANCE_NAME
  }
}
