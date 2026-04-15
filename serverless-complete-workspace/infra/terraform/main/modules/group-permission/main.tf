# Group Permission Module
# Assigns permissions to a Databricks group across multiple scopes:
# - Account level (group to workspace assignment)
# - Workspace level (via databricks_mws_permission_assignment)
# - Catalog / Schema / Table level (Unity Catalog grants via databricks_grant)

# ---- Account-level group to workspace assignment ----
resource "databricks_mws_permission_assignment" "workspace" {
  provider     = databricks.mws
  count        = var.workspace_id != null ? 1 : 0
  workspace_id = var.workspace_id
  principal_id = var.group_id
  permissions  = var.workspace_permissions
}

# ---- Catalog grants ----
resource "databricks_grant" "catalog" {
  for_each   = var.catalog_grants
  catalog    = each.key
  principal  = var.group_name
  privileges = each.value
}

# ---- Schema grants ----
resource "databricks_grant" "schema" {
  for_each   = var.schema_grants
  schema     = each.key
  principal  = var.group_name
  privileges = each.value
}

# ---- Table grants ----
resource "databricks_grant" "table" {
  for_each   = var.table_grants
  table      = each.key
  principal  = var.group_name
  privileges = each.value
}
