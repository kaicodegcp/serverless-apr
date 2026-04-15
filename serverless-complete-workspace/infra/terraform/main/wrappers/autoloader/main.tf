# Wrapper: autoloader (SQS Event Notification -> S3 -> catalog.schema.table)
module "autoloader" {
  source = "../../modules/autoloader"

  name_prefix               = var.name_prefix
  source_s3_bucket_arn      = var.source_s3_bucket_arn
  source_s3_bucket_id       = var.source_s3_bucket_id
  source_s3_path            = var.source_s3_path
  databricks_role_arn       = var.databricks_role_arn
  target_catalog            = var.target_catalog
  target_schema             = var.target_schema
  target_table              = var.target_table
  notebook_path             = var.notebook_path
  source_data_format        = var.source_data_format
  configure_s3_notification = var.configure_s3_notification
  s3_event_types            = var.s3_event_types
  s3_filter_prefix          = var.s3_filter_prefix
  s3_filter_suffix          = var.s3_filter_suffix
  sqs_visibility_timeout    = var.sqs_visibility_timeout
  sqs_message_retention     = var.sqs_message_retention
  sqs_receive_wait_time     = var.sqs_receive_wait_time
  enable_dead_letter_queue  = var.enable_dead_letter_queue
  pipeline_storage_path     = var.pipeline_storage_path
  pipeline_channel          = var.pipeline_channel
  pipeline_edition          = var.pipeline_edition
  enable_photon             = var.enable_photon
  continuous_mode           = var.continuous_mode
  checkpoint_path           = var.checkpoint_path
  pipeline_cluster          = var.pipeline_cluster
  extra_configuration       = var.extra_configuration
  tags                      = var.tags
}
