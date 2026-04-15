# Wrapper: group-permission
# Assigns permissions to a group across account / workspace / catalog / schema / table

module "group_permission" {
  source = "../../modules/group-permission"

  providers = {
    databricks     = databricks
    databricks.mws = databricks.mws
  }

  group_name            = var.group_name
  group_id              = var.group_id
  workspace_id          = var.workspace_id
  workspace_permissions = var.workspace_permissions
  catalog_grants        = var.catalog_grants
  schema_grants         = var.schema_grants
  table_grants          = var.table_grants
}
