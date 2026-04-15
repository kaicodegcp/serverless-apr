# Wrapper: user-permission
# Assigns permissions to a user across account / workspace / catalog / schema / table

module "user_permission" {
  source = "../../modules/user-permission"

  providers = {
    databricks     = databricks
    databricks.mws = databricks.mws
  }

  user_name             = var.user_name
  user_id               = var.user_id
  workspace_id          = var.workspace_id
  workspace_permissions = var.workspace_permissions
  catalog_grants        = var.catalog_grants
  schema_grants         = var.schema_grants
  table_grants          = var.table_grants
}
