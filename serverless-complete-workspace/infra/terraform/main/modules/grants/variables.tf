variable "grant_list" {
  description = "List of grant objects. Each object specifies resource_type (catalog|schema|table|external_location|storage_credential), resource_name, principal, and privileges."
  type = list(object({
    resource_type = string
    resource_name = string
    principal     = string
    privileges    = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for g in var.grant_list :
      contains(["catalog", "schema", "table", "external_location", "storage_credential"], g.resource_type)
    ])
    error_message = "resource_type must be one of: catalog, schema, table, external_location, storage_credential."
  }
}
