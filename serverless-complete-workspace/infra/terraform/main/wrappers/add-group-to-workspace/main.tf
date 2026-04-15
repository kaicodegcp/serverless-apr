# Wrapper: add-group-to-workspace
# Creates or references a group and assigns it to a Databricks workspace

module "group" {
  source = "../../modules/group"

  display_name               = var.display_name
  allow_cluster_create       = var.allow_cluster_create
  allow_instance_pool_create = var.allow_instance_pool_create
  databricks_sql_access      = var.databricks_sql_access
  workspace_access           = var.workspace_access
  external_id                = var.external_id
  force                      = var.force
  acl_principal_id           = var.acl_principal_id
}

# Assign the group to a workspace via account-level API
resource "databricks_mws_permission_assignment" "group_workspace" {
  provider     = databricks.mws
  count        = var.workspace_id != null ? 1 : 0
  workspace_id = var.workspace_id
  principal_id = module.group.id
  permissions  = var.workspace_permissions
}
