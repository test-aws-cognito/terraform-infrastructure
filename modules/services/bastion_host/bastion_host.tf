resource "aws_instance" "bastion_host" {
  ami           = var.AMI
  instance_type = var.EC2_TYPE
  key_name      = var.KEY_NAME

  subnet_id              = var.SUBNET_ID
  vpc_security_group_ids = [aws_security_group.sg_bastion_host.id]

  tags = {
    Name = "terraform-bastion-host"
  }
}
