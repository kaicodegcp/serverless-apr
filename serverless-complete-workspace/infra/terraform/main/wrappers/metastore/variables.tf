variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "name" {
  description = "Name of the metastore"
  type        = string
}

variable "storage_root" {
  description = "S3 bucket path for the metastore root storage"
  type        = string
}

variable "owner" {
  description = "Owner of the metastore"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS region for the metastore"
  type        = string
}

variable "force_destroy" {
  description = "Force destroy the metastore even if it contains data"
  type        = bool
  default     = false
}

variable "delta_sharing_scope" {
  description = "Delta sharing scope (INTERNAL, INTERNAL_AND_EXTERNAL)"
  type        = string
  default     = "INTERNAL_AND_EXTERNAL"
}

variable "delta_sharing_recipient_token_lifetime_in_seconds" {
  description = "Delta sharing recipient token lifetime in seconds (2.11: Set based on data sensitivity, e.g., 3600 for 1 hour)"
  type        = number
  default     = 3600  # 1 hour for security
}

variable "delta_sharing_organization_name" {
  description = "Delta sharing organization name"
  type        = string
  default     = null
}
