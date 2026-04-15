# =============================================================================
# Root Module: Databricks Serverless Complete Workspace
# =============================================================================
# This root module invokes the complete-workspace-serverless child module to
# provision:
#   - AWS prerequisites (S3, KMS, bucket policy)
#   - Databricks MWS storage configuration + customer-managed keys
#   - Databricks serverless workspace (compute_mode = SERVERLESS)
#   - Unity Catalog metastore assignment
#   - Optional: service principal, Unity Catalog creation
# =============================================================================

module "complete_workspace_serverless" {
  source = "./modules/complete-workspace-serverless"

  providers = {
    databricks.mws = databricks.mws
  }

  # AWS Configuration
  aws_region = var.aws_region
  tags       = var.tags

  # Databricks Account Configuration
  databricks_account_id             = var.databricks_account_id
  databricks_aws_account_id         = var.databricks_aws_account_id
  databricks_cross_account_role_arn = var.databricks_cross_account_role_arn

  # Workspace Configuration
  name_prefix                = var.name_prefix
  workspace_name             = var.workspace_name
  workspace_root_bucket_name = var.workspace_root_bucket_name
  force_destroy_buckets      = var.force_destroy_buckets

  # Unity Catalog / Metastore
  existing_metastore_name    = var.existing_metastore_name
  unity_catalog_name         = var.unity_catalog_name
  unity_catalog_storage_root = var.unity_catalog_storage_root
  unity_catalog_owner        = var.unity_catalog_owner

  # Service Principal
  enable_service_principal       = var.enable_service_principal
  service_principal_display_name = var.service_principal_display_name
}
