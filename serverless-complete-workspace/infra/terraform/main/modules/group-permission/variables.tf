variable "group_name" {
  description = "Display name of the Databricks group"
  type        = string
}

variable "group_id" {
  description = "Numeric ID of the Databricks group (required for workspace assignment)"
  type        = string
  default     = null
}

variable "workspace_id" {
  description = "Workspace ID for workspace-level permission assignment. Set to null to skip."
  type        = string
  default     = null
}

variable "workspace_permissions" {
  description = "Workspace-level permissions list (e.g. [\"USER\", \"ADMIN\"])"
  type        = list(string)
  default     = ["USER"]
}

variable "catalog_grants" {
  description = "Map of catalog_name => list of privileges for the group"
  type        = map(list(string))
  default     = {}
}

variable "schema_grants" {
  description = "Map of full_schema_name (catalog.schema) => list of privileges for the group"
  type        = map(list(string))
  default     = {}
}

variable "table_grants" {
  description = "Map of full_table_name (catalog.schema.table) => list of privileges for the group"
  type        = map(list(string))
  default     = {}
}
