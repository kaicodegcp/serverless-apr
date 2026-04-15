# =============================================================================
# Root Module Variables
# =============================================================================

variable "databricks_account_id" {
  description = "Databricks Account ID (used by account-level MWS resources). Typically same value as env var DATABRICKS_ACCOUNT_ID."
  type        = string
}

variable "databricks_aws_account_id" {
  description = "Databricks AWS account ID (used in S3 bucket policy principal). Default is the standard Databricks commercial AWS account."
  type        = string
}

variable "aws_region" {
  description = "AWS region where the workspace and S3 bucket will be created."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for resource names (e.g. MWS storage config, KMS alias)."
  type        = string
  default     = "serverless-complete"
}

variable "workspace_name" {
  description = "Name for the new Databricks serverless workspace."
  type        = string
}

variable "workspace_root_bucket_name" {
  description = "S3 bucket name for the workspace root storage configuration. Must be globally unique."
  type        = string
}

variable "existing_metastore_name" {
  description = "Existing Unity Catalog metastore name to assign to the workspace."
  type        = string
}

variable "force_destroy_buckets" {
  description = "Allow Terraform to delete non-empty S3 buckets on destroy (use with caution)."
  type        = bool
  default     = false
}

variable "databricks_cross_account_role_arn" {
  description = "Optional Databricks cross-account IAM role ARN for EBS KMS (leave null if not using)."
  type        = string
  default     = null
}

variable "enable_service_principal" {
  description = "Whether to create a service principal for workspace automation."
  type        = bool
  default     = false
}

variable "service_principal_display_name" {
  description = "Display name for the workspace automation service principal."
  type        = string
  default     = "serverless-workspace-sp"
}

variable "unity_catalog_name" {
  description = "Name for the Unity Catalog to create in the workspace. Leave empty to skip."
  type        = string
  default     = ""
}

variable "unity_catalog_storage_root" {
  description = "S3 URI for the Unity Catalog default storage root (e.g. s3://my-bucket/unity-catalog)."
  type        = string
  default     = ""
}

variable "unity_catalog_owner" {
  description = "Owner of the Unity Catalog (user or group)."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to AWS resources."
  type        = map(string)
  default     = {}
}
