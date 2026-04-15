# Wrapper: workspace-serverless
# Creates a complete Databricks serverless workspace with S3, KMS, MWS config,
# metastore assignment, optional service principal, and optional Unity Catalog.
module "workspace_serverless" {
  source = "../../modules/complete-workspace-serverless"

  providers = {
    databricks.mws = databricks.mws
  }

  aws_region                        = var.aws_region
  databricks_account_id             = var.databricks_account_id
  databricks_aws_account_id         = var.databricks_aws_account_id
  databricks_cross_account_role_arn = var.databricks_cross_account_role_arn
  name_prefix                       = var.name_prefix
  workspace_name                    = var.workspace_name
  workspace_root_bucket_name        = var.workspace_root_bucket_name
  existing_metastore_name           = var.existing_metastore_name
  force_destroy_buckets             = var.force_destroy_buckets
  enable_service_principal          = var.enable_service_principal
  service_principal_display_name    = var.service_principal_display_name
  unity_catalog_name                = var.unity_catalog_name
  unity_catalog_storage_root        = var.unity_catalog_storage_root
  unity_catalog_owner               = var.unity_catalog_owner
  tags                              = var.tags
}
