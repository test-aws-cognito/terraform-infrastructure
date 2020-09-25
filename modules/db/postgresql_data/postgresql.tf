data "aws_instance" "postgresql" {
  filter {
    name   = "tag:Name"
    values = [var.INSTANCE_NAME]
  }
}
