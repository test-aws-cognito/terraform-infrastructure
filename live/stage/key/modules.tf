module "key" {
  source = "../../../modules/security/keys"

  KEY_NAME = var.EC2_KEY_NAME
}
