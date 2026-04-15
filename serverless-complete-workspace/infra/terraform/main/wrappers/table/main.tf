# Wrapper: table
module "table" {
  source = "../../modules/table"

  name                    = var.name
  catalog_name            = var.catalog_name
  schema_name             = var.schema_name
  table_type              = var.table_type
  data_source_format      = var.data_source_format
  storage_location        = var.storage_location
  storage_credential_name = var.storage_credential_name
  view_definition         = var.view_definition
  comment                 = var.comment
  properties              = var.properties
  owner                   = var.owner
  warehouse_id            = var.warehouse_id
  columns                 = var.columns
}
