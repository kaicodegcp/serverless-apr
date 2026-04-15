variable "bucket_name" {
  description = "Name of the S3 root storage bucket for Databricks workspace"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "databricks_aws_account_id" {
  description = "Databricks AWS account ID (414351767826 for commercial)"
  type        = string
  default     = "414351767826"
}

variable "create_cross_account_role" {
  description = "Whether to create an IAM cross-account role for Databricks"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Force destroy S3 bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
