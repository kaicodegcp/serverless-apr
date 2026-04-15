output "catalog_id" {
  description = "The ID of the created catalog"
  value       = module.catalog_creation.catalog_id
}

output "catalog_name" {
  description = "The name of the created catalog"
  value       = module.catalog_creation.catalog_name
}

output "storage_credential_id" {
  description = "The ID of the storage credential"
  value       = module.catalog_creation.storage_credential_id
}

output "external_location_id" {
  description = "The ID of the external location"
  value       = module.catalog_creation.external_location_id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket created for catalog storage"
  value       = module.catalog_creation.s3_bucket_name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role for catalog S3 access"
  value       = module.catalog_creation.iam_role_arn
}

output "schema_ids" {
  description = "Map of schema IDs"
  value       = module.catalog_creation.schema_ids
}
