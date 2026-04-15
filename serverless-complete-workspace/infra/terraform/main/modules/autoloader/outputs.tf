output "sqs_queue_url" {
  description = "URL of the SQS queue for S3 event notifications"
  value       = aws_sqs_queue.s3_events.url
}

output "sqs_queue_arn" {
  description = "ARN of the SQS queue"
  value       = aws_sqs_queue.s3_events.arn
}

output "sqs_dlq_arn" {
  description = "ARN of the dead letter queue"
  value       = var.enable_dead_letter_queue ? aws_sqs_queue.s3_events_dlq[0].arn : null
}

output "pipeline_id" {
  description = "ID of the DLT autoloader pipeline"
  value       = databricks_pipeline.autoloader.id
}

output "pipeline_name" {
  description = "Name of the DLT autoloader pipeline"
  value       = databricks_pipeline.autoloader.name
}

output "pipeline_url" {
  description = "URL to access the DLT pipeline"
  value       = databricks_pipeline.autoloader.url
}

output "target_table_full_name" {
  description = "Full name of the target table (catalog.schema.table)"
  value       = "${var.target_catalog}.${var.target_schema}.${var.target_table}"
}
