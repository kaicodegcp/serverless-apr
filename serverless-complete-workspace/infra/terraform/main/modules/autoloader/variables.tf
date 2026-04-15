variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "source_s3_bucket_arn" {
  description = "ARN of the source S3 bucket for event notifications"
  type        = string
}

variable "source_s3_bucket_id" {
  description = "ID/name of the source S3 bucket"
  type        = string
}

variable "source_s3_path" {
  description = "S3 path for autoloader source data (e.g. s3://bucket/path/)"
  type        = string
}

variable "databricks_role_arn" {
  description = "ARN of the IAM role used by Databricks to consume SQS messages"
  type        = string
}

variable "target_catalog" {
  description = "Target Unity Catalog name"
  type        = string
}

variable "target_schema" {
  description = "Target schema name"
  type        = string
}

variable "target_table" {
  description = "Target table name"
  type        = string
}

variable "notebook_path" {
  description = "Path to the DLT notebook for autoloader pipeline"
  type        = string
}

variable "source_data_format" {
  description = "Format of source data (JSON, CSV, PARQUET, etc.)"
  type        = string
  default     = "JSON"
}

variable "configure_s3_notification" {
  description = "Whether to configure S3 bucket notification (set false if already configured)"
  type        = bool
  default     = true
}

variable "s3_event_types" {
  description = "S3 event types to trigger notifications"
  type        = list(string)
  default     = ["s3:ObjectCreated:*"]
}

variable "s3_filter_prefix" {
  description = "S3 key prefix filter for notifications"
  type        = string
  default     = ""
}

variable "s3_filter_suffix" {
  description = "S3 key suffix filter for notifications"
  type        = string
  default     = ""
}

variable "sqs_visibility_timeout" {
  description = "SQS visibility timeout in seconds"
  type        = number
  default     = 300
}

variable "sqs_message_retention" {
  description = "SQS message retention in seconds"
  type        = number
  default     = 345600
}

variable "sqs_receive_wait_time" {
  description = "SQS long-poll wait time in seconds"
  type        = number
  default     = 20
}

variable "enable_dead_letter_queue" {
  description = "Enable dead letter queue for failed messages"
  type        = bool
  default     = true
}

variable "pipeline_storage_path" {
  description = "Storage path for the DLT pipeline"
  type        = string
  default     = null
}

variable "pipeline_channel" {
  description = "DLT pipeline channel (CURRENT or PREVIEW)"
  type        = string
  default     = "CURRENT"
}

variable "pipeline_edition" {
  description = "DLT pipeline edition (CORE, PRO, ADVANCED)"
  type        = string
  default     = "ADVANCED"
}

variable "enable_photon" {
  description = "Enable Photon acceleration"
  type        = bool
  default     = true
}

variable "continuous_mode" {
  description = "Run pipeline in continuous mode"
  type        = bool
  default     = false
}

variable "checkpoint_path" {
  description = "Checkpoint path for autoloader"
  type        = string
  default     = ""
}

variable "pipeline_cluster" {
  description = "Pipeline cluster configuration"
  type = object({
    label       = optional(string, "default")
    num_workers = optional(number)
    autoscale = optional(object({
      min_workers = number
      max_workers = number
      mode        = optional(string, "ENHANCED")
    }))
  })
  default = null
}

variable "extra_configuration" {
  description = "Additional pipeline configuration parameters"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
