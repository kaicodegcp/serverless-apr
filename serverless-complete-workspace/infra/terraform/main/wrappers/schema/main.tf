# Wrapper: schema
module "schema" {
  source = "../../modules/schema"

  catalog_name = var.catalog_name
  name = var.name
  comment = var.comment
  properties = var.properties
  storage_root = var.storage_root
  owner = var.owner
  force_destroy = var.force_destroy
}
