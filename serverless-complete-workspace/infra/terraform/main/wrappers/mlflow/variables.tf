variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "owner_group_name" {
  description = "Owner group that gets CAN_MANAGE on the experiment. Set to null to skip."
  type        = string
  default     = null
}

variable "additional_access_control_list" {
  description = "Additional ACL entries for the MLflow experiment"
  type = list(object({
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
    permission_level       = string
  }))
  default = []
}

variable "name" {
  description = "Name of the MLflow experiment"
  type        = string
}

variable "artifact_location" {
  description = "Artifact location for the experiment"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the experiment"
  type        = string
  default     = null
}
