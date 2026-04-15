# Wrapper: external-location
module "external_location" {
  source = "../../modules/external-location"

  name = var.name
  url = var.url
  credential_name = var.credential_name
  comment = var.comment
  owner = var.owner
  read_only = var.read_only
  force_update = var.force_update
  force_destroy = var.force_destroy
  isolation_mode = var.isolation_mode
  skip_validation = var.skip_validation
}
