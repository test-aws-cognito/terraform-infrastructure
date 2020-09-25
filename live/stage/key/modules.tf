module "configuration" {
  source = "../../../configuration"
}

module "key" {
  source = "../../../modules/security/keys"

  KEY_NAME = module.configuration.EC2_KEY_NAME
}
