output "workspace_id" {
  description = "Created Databricks serverless workspace ID."
  value       = module.workspace_serverless.workspace_id
}

output "workspace_url" {
  description = "Created Databricks workspace URL."
  value       = module.workspace_serverless.workspace_url
}

output "storage_configuration_id" {
  description = "Databricks account storage configuration ID."
  value       = module.workspace_serverless.storage_configuration_id
}

output "kms_key_arn" {
  description = "AWS KMS key ARN used for workspace encryption."
  value       = module.workspace_serverless.kms_key_arn
}

output "metastore_id" {
  description = "Assigned Unity Catalog metastore ID."
  value       = module.workspace_serverless.metastore_id
}

output "root_bucket_name" {
  description = "Name of the S3 root storage bucket."
  value       = module.workspace_serverless.root_bucket_name
}

output "service_principal_id" {
  description = "Service principal application ID (if created)."
  value       = module.workspace_serverless.service_principal_id
}

output "unity_catalog_name" {
  description = "Name of the Unity Catalog (if created)."
  value       = module.workspace_serverless.unity_catalog_name
}
