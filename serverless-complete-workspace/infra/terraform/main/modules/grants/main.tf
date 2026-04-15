# Unity Catalog Grants module
# Supports granting privileges on: catalog, schema, table, external_location, storage_credential
# Uses databricks_grant (singular) for each principal to avoid conflicts

resource "databricks_grant" "this" {
  for_each = { for g in var.grant_list : "${g.resource_type}_${g.resource_name}_${g.principal}" => g }

  catalog            = each.value.resource_type == "catalog" ? each.value.resource_name : null
  schema             = each.value.resource_type == "schema" ? each.value.resource_name : null
  table              = each.value.resource_type == "table" ? each.value.resource_name : null
  external_location  = each.value.resource_type == "external_location" ? each.value.resource_name : null
  storage_credential = each.value.resource_type == "storage_credential" ? each.value.resource_name : null

  principal  = each.value.principal
  privileges = each.value.privileges
}
