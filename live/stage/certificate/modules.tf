module "configuration" {
  source = "../../../configuration"
}

// This should be done only once per whole testign period.
// AWS limit certificate uploads to relatively small number.
// New account has only 10 certificates and 20 uploads per year.
// Old accounts may have 1000 certs and 2000 uploads.
module "ssl_certificate" {
  source = "../../../modules/security/certificate"

  DOMAIN_NAME = module.configuration.SSL_CERTIFICATE_DOMAIN_NAME
  # One hundred years should be sufficient to finish your task
  VALIDITY_PERIOD_HOURS = 24 * 365 * 100
}
