output "BASTION_HOST_PUBLIC_IP" {
  value = aws_instance.bastion_host.public_ip
}
