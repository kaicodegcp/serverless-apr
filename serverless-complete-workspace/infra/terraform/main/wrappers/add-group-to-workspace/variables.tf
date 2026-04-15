variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "workspace_id" {
  description = "Workspace ID to assign the group to. Set to null to skip workspace assignment."
  type        = string
  default     = null
}

variable "workspace_permissions" {
  description = "Workspace permissions for the group (e.g. USER, ADMIN)"
  type        = list(string)
  default     = ["USER"]
}

variable "display_name" {
  description = "Display name of the group"
  type        = string
}

variable "allow_cluster_create" {
  description = "Allow the group to create clusters"
  type        = bool
  default     = false
}

variable "allow_instance_pool_create" {
  description = "Allow the group to create instance pools"
  type        = bool
  default     = false
}

variable "databricks_sql_access" {
  description = "Allow the group to access Databricks SQL"
  type        = bool
  default     = false
}

variable "workspace_access" {
  description = "Allow the group to access the workspace"
  type        = bool
  default     = true
}

variable "external_id" {
  description = "External ID for SCIM provisioning"
  type        = string
  default     = null
}

variable "force" {
  description = "Force the group to be created even if it already exists"
  type        = bool
  default     = false
}

variable "acl_principal_id" {
  description = "ACL principal ID"
  type        = string
  default     = null
}
