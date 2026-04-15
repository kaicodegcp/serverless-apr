# Wrapper: mws-credentials
module "mws_credentials" {
  source = "../../modules/mws-credentials"

  account_id = var.account_id
  credentials_name = var.credentials_name
  role_arn = var.role_arn
}
