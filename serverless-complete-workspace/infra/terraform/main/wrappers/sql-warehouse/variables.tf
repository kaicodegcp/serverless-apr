variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "owner_group_name" {
  description = "Owner group that gets CAN_MANAGE on the warehouse. Set to null to skip."
  type        = string
  default     = null
}

variable "additional_access_control_list" {
  description = "Additional ACL entries for the SQL warehouse"
  type = list(object({
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
    permission_level       = string
  }))
  default = []
}

variable "name" {
  description = "Name of the SQL warehouse"
  type        = string
}

variable "cluster_size" {
  description = "Size of the cluster"
  type        = string
}

variable "max_num_clusters" {
  description = "Maximum number of clusters"
  type        = number
  default     = 1
}

variable "min_num_clusters" {
  description = "Minimum number of clusters"
  type        = number
  default     = 1
}

variable "auto_stop_mins" {
  description = "Auto-stop time in minutes"
  type        = number
  default     = 120
}

variable "enable_photon" {
  description = "Enable Photon acceleration"
  type        = bool
  default     = true
}

variable "enable_serverless_compute" {
  description = "Enable serverless compute"
  type        = bool
  default     = true
}

variable "spot_instance_policy" {
  description = "Spot instance policy"
  type        = string
  default     = "COST_OPTIMIZED"
}

variable "warehouse_type" {
  description = "Warehouse type (PRO, CLASSIC)"
  type        = string
  default     = "PRO"
}

variable "channel" {
  description = "Channel configuration"
  type = object({
    name = string
  })
  default = null
}

variable "custom_tags" {
  description = "Custom tags for the warehouse"
  type        = map(string)
  default     = null
}
