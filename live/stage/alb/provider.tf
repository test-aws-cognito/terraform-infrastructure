provider "aws" {
  region                  = module.configuration.REGION
  shared_credentials_file = module.configuration.CREDENTIALS_FILE
  profile                 = module.configuration.CREDENTIALS_PROFILE
}
