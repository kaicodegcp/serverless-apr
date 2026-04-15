output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = module.autoloader.sqs_queue_url
}

output "sqs_queue_arn" {
  description = "ARN of the SQS queue"
  value       = module.autoloader.sqs_queue_arn
}

output "pipeline_id" {
  description = "ID of the DLT autoloader pipeline"
  value       = module.autoloader.pipeline_id
}

output "pipeline_name" {
  description = "Name of the DLT autoloader pipeline"
  value       = module.autoloader.pipeline_name
}

output "target_table_full_name" {
  description = "Full name of the target table (catalog.schema.table)"
  value       = module.autoloader.target_table_full_name
}
