variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "owner_group_name" {
  description = "Owner group that gets CAN_MANAGE on the notebook. Set to null to skip."
  type        = string
  default     = null
}

variable "additional_access_control_list" {
  description = "Additional ACL entries for the notebook"
  type = list(object({
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
    permission_level       = string
  }))
  default = []
}

variable "path" {
  description = "The path to the notebook in the Databricks workspace"
  type        = string
}

variable "language" {
  description = "The language of the notebook (PYTHON, SCALA, SQL, or R)"
  type        = string
}

variable "format" {
  description = "The format of the notebook"
  type        = string
  default     = "SOURCE"
}

variable "content_base64" {
  description = "The base64-encoded content of the notebook"
  type        = string
  default     = null
}

variable "notebook_source" {
  description = "Path to the notebook file on the local filesystem"
  type        = string
  default     = null
}
