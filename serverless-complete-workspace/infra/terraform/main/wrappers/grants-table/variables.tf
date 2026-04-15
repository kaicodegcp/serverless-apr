variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "grant_list" {
  description = "List of grant objects for tables. Each specifies resource_type=table, the full table name (catalog.schema.table), principal, and privileges."
  type = list(object({
    resource_type = string
    resource_name = string
    principal     = string
    privileges    = list(string)
  }))
  default = []
}
