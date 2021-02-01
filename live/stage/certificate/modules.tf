module "ssl_certificate" {
  source = "../../../modules/security/certificate"

  DOMAIN_NAME = var.SSL_CERTIFICATE_DOMAIN_NAME
  # One hundred years should be sufficient to finish your task
  VALIDITY_PERIOD_HOURS = 24 * 365 * 100
}
