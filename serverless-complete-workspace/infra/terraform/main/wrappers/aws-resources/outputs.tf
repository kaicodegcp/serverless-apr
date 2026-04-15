output "bucket_id" {
  description = "The ID of the S3 root storage bucket"
  value       = module.aws_resources.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 root storage bucket"
  value       = module.aws_resources.bucket_arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = module.aws_resources.kms_key_arn
}

output "kms_key_id" {
  description = "The ID of the KMS key"
  value       = module.aws_resources.kms_key_id
}

output "cross_account_role_arn" {
  description = "The ARN of the cross-account IAM role"
  value       = module.aws_resources.cross_account_role_arn
}
