output "catalog_id" {
  description = "Catalog ID"
  value       = module.catalog_creation.catalog_id
}

output "catalog_name" {
  description = "Catalog name (safe for SQL)"
  value       = module.catalog_creation.catalog_name
}

output "storage_credential_id" {
  description = "Storage credential ID"
  value       = module.catalog_creation.storage_credential_id
}

output "external_location_name" {
  description = "External location name"
  value       = module.catalog_creation.external_location_name
}

output "external_location_id" {
  description = "External location ID"
  value       = module.catalog_creation.external_location_id
}

output "s3_bucket_name" {
  description = "S3 bucket name for catalog storage"
  value       = module.catalog_creation.s3_bucket_name
}

output "iam_role_arn" {
  description = "IAM role ARN used by the catalog storage credential"
  value       = module.catalog_creation.iam_role_arn
}

output "kms_key_arn" {
  description = "KMS key ARN for catalog storage"
  value       = module.catalog_creation.kms_key_arn
}

output "schema_ids" {
  description = "Map of schema name to schema ID"
  value       = module.catalog_creation.schema_ids
}
