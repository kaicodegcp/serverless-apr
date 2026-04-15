variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "workspace_id" {
  description = "Databricks workspace ID (used in naming and catalog comment)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names (e.g. workspace name). Used to build bucket/role/catalog names."
  type        = string
}

variable "aws_partition" {
  description = "AWS partition (aws or aws-us-gov)"
  type        = string
  default     = "aws"
}

variable "cmk_admin_arn" {
  description = "ARN of the CMK admin principal. Defaults to account root if not specified."
  type        = string
  default     = null
}

variable "unity_catalog_iam_arn" {
  description = "Databricks Unity Catalog master role ARN for IAM trust policy"
  type        = string
  default     = "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"
}

variable "catalog_owner" {
  description = "Owner of the catalog (group name or service principal)"
  type        = string
  default     = "account users"
}

variable "catalog_properties" {
  description = "Properties for the catalog"
  type        = map(string)
  default     = {}
}

variable "catalog_isolation_mode" {
  description = "Catalog isolation mode (ISOLATED or OPEN)"
  type        = string
  default     = "ISOLATED"

  validation {
    condition     = contains(["ISOLATED", "OPEN"], var.catalog_isolation_mode)
    error_message = "Catalog isolation mode must be ISOLATED or OPEN."
  }
}

variable "force_destroy" {
  description = "Allow force destroy of catalog and schema resources"
  type        = bool
  default     = false
}

variable "schemas" {
  description = "Map of schema names to schema config (comment and optional permissions)"
  type = map(object({
    comment = string
    permissions = optional(object({
      groups             = map(list(string))
      service_principals = map(list(string))
    }))
  }))
  default = {}
}

variable "databricks_service_principal_app_ids" {
  description = "Service principal name to application ID map (used for schema and catalog permissions)"
  type        = map(string)
  default     = {}
}

variable "permissions" {
  description = "Catalog-level permissions (groups and service principals with list of privileges)"
  type = object({
    groups             = map(list(string))
    service_principals = map(list(string))
  })
  default = {
    groups             = {}
    service_principals = {}
  }
}

variable "tags" {
  description = "Tags for AWS resources"
  type        = map(string)
  default     = {}
}
