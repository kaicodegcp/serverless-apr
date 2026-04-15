output "bucket_id" {
  description = "The ID of the S3 root storage bucket"
  value       = aws_s3_bucket.root_storage.id
}

output "bucket_arn" {
  description = "The ARN of the S3 root storage bucket"
  value       = aws_s3_bucket.root_storage.arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.workspace.arn
}

output "kms_key_id" {
  description = "The ID of the KMS key"
  value       = aws_kms_key.workspace.key_id
}

output "kms_alias_name" {
  description = "The alias name of the KMS key"
  value       = aws_kms_alias.workspace.name
}

output "cross_account_role_arn" {
  description = "The ARN of the cross-account IAM role"
  value       = var.create_cross_account_role ? aws_iam_role.cross_account[0].arn : null
}

output "cross_account_role_name" {
  description = "The name of the cross-account IAM role"
  value       = var.create_cross_account_role ? aws_iam_role.cross_account[0].name : null
}
