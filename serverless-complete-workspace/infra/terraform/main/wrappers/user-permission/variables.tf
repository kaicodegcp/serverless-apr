variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "user_name" {
  description = "Email or user name of the Databricks user"
  type        = string
}

variable "user_id" {
  description = "Numeric ID of the Databricks user (required for workspace assignment)"
  type        = string
  default     = null
}

variable "workspace_id" {
  description = "Workspace ID for workspace-level permission assignment. Set to null to skip."
  type        = string
  default     = null
}

variable "workspace_permissions" {
  description = "Workspace-level permissions list"
  type        = list(string)
  default     = ["USER"]
}

variable "catalog_grants" {
  description = "Map of catalog_name => list of privileges"
  type        = map(list(string))
  default     = {}
}

variable "schema_grants" {
  description = "Map of full_schema_name (catalog.schema) => list of privileges"
  type        = map(list(string))
  default     = {}
}

variable "table_grants" {
  description = "Map of full_table_name (catalog.schema.table) => list of privileges"
  type        = map(list(string))
  default     = {}
}
