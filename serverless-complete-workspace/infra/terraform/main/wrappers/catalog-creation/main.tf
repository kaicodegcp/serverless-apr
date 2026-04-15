# Wrapper: catalog-creation
module "catalog_creation" {
  source = "../../modules/catalog-creation"

  workspace_id = var.workspace_id
  name_prefix = var.name_prefix
  aws_partition = var.aws_partition
  cmk_admin_arn = var.cmk_admin_arn
  unity_catalog_iam_arn = var.unity_catalog_iam_arn
  catalog_owner = var.catalog_owner
  catalog_properties = var.catalog_properties
  catalog_isolation_mode = var.catalog_isolation_mode
  force_destroy = var.force_destroy
  schemas = var.schemas
  databricks_service_principal_app_ids = var.databricks_service_principal_app_ids
  permissions = var.permissions
  tags = var.tags
}
