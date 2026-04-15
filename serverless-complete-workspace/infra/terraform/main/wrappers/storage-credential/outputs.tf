output "id" {
  description = "The ID of the storage credential"
  value       = module.storage_credential.id
}

output "name" {
  description = "The name of the storage credential"
  value       = module.storage_credential.name
}

output "storage_credential_id" {
  description = "The storage credential ID"
  value       = module.storage_credential.storage_credential_id
}

output "external_id" {
  description = "External ID assigned by Databricks for the AWS IAM role trust policy (when aws_iam_role is set)"
  value       = module.storage_credential.external_id
}
