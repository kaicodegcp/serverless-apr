# =============================================================================
# Outputs for complete-workspace-serverless module
# =============================================================================

output "workspace_id" {
  description = "Created Databricks serverless workspace ID."
  value       = databricks_mws_workspaces.this.workspace_id
}

output "workspace_url" {
  description = "Created Databricks workspace URL."
  value       = databricks_mws_workspaces.this.workspace_url
}

output "storage_configuration_id" {
  description = "Databricks account storage configuration ID."
  value       = databricks_mws_storage_configurations.this.storage_configuration_id
}

output "kms_key_arn" {
  description = "AWS KMS key ARN used for workspace encryption."
  value       = aws_kms_key.workspace.arn
}

output "kms_key_alias" {
  description = "AWS KMS key alias for the workspace."
  value       = aws_kms_alias.workspace.name
}

output "metastore_id" {
  description = "Assigned Unity Catalog metastore ID."
  value       = data.databricks_metastore.existing.metastore_id
}

output "root_bucket_name" {
  description = "Name of the S3 root storage bucket."
  value       = aws_s3_bucket.workspace_root.id
}

output "root_bucket_arn" {
  description = "ARN of the S3 root storage bucket."
  value       = aws_s3_bucket.workspace_root.arn
}

output "managed_services_cmk_id" {
  description = "Databricks customer-managed key ID for managed services."
  value       = databricks_mws_customer_managed_keys.managed_services.customer_managed_key_id
}

output "storage_cmk_id" {
  description = "Databricks customer-managed key ID for storage."
  value       = databricks_mws_customer_managed_keys.storage.customer_managed_key_id
}

output "service_principal_id" {
  description = "Service principal application ID (if created)."
  value       = var.enable_service_principal ? databricks_service_principal.workspace_sp[0].application_id : null
}

output "unity_catalog_name" {
  description = "Name of the Unity Catalog (if created)."
  value       = var.unity_catalog_name != "" ? databricks_catalog.workspace_catalog[0].name : null
}
