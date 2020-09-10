output "terraform_vpc" {
  value = data.aws_vpc.terraform_vpc
}

output "terraform_subnets_ids_public" {
  value = data.aws_subnet_ids.terraform_public_subnets
}

output "terraform_subnets_ids_private" {
  value = data.aws_subnet_ids.terraform_private_subnets
}
