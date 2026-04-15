# =============================================================================
# Catalog Creation - Outputs
# =============================================================================

output "catalog_id" {
  description = "Catalog ID"
  value       = databricks_catalog.default.id
}

output "catalog_name" {
  description = "Catalog name (safe for SQL)"
  value       = databricks_catalog.default.name
}

output "storage_credential_id" {
  description = "Storage credential ID"
  value       = databricks_storage_credential.catalog.id
}

output "external_location_name" {
  description = "External location name"
  value       = databricks_external_location.catalog.name
}

output "external_location_id" {
  description = "External location ID"
  value       = databricks_external_location.catalog.id
}

output "s3_bucket_name" {
  description = "S3 bucket name for catalog storage"
  value       = module.s3_unity_catalog.s3_bucket_id
}

output "iam_role_arn" {
  description = "IAM role ARN used by the catalog storage credential"
  value       = local.uc_iam_arn
}

output "kms_key_arn" {
  description = "KMS key ARN for catalog storage"
  value       = module.kms_catalog_storage.key_arn
}

# Schema outputs (from var.schemas)
output "schema_ids" {
  description = "Map of schema name to schema ID"
  value       = { for k, s in module.schema : k => s.id }
}
