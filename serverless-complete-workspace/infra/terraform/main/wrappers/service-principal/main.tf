# Wrapper: service-principal
module "service_principal" {
  source = "../../modules/service-principal"

  application_id = var.application_id
  display_name = var.display_name
  active = var.active
  allow_cluster_create = var.allow_cluster_create
  allow_instance_pool_create = var.allow_instance_pool_create
  databricks_sql_access = var.databricks_sql_access
  workspace_access = var.workspace_access
  external_id = var.external_id
  force = var.force
  home = var.home
  repos = var.repos
  acl_principal_id = var.acl_principal_id
}
