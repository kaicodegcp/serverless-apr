# Wrapper: add-service-principal-to-workspace
# Adds a service principal to a Databricks workspace with specified permissions

module "service_principal" {
  source = "../../modules/service-principal"

  application_id             = var.application_id
  display_name               = var.display_name
  active                     = var.active
  allow_cluster_create       = var.allow_cluster_create
  allow_instance_pool_create = var.allow_instance_pool_create
  databricks_sql_access      = var.databricks_sql_access
  workspace_access           = var.workspace_access
  external_id                = var.external_id
  force                      = var.force
  home                       = var.home
  repos                      = var.repos
  acl_principal_id           = var.acl_principal_id
}

# Assign the service principal to a workspace via account-level API
resource "databricks_mws_permission_assignment" "sp_workspace" {
  provider     = databricks.mws
  count        = var.workspace_id != null ? 1 : 0
  workspace_id = var.workspace_id
  principal_id = module.service_principal.id
  permissions  = var.workspace_permissions
}
