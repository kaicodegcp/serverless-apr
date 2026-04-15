variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "owner_group_name" {
  description = "Owner group that gets CAN_MANAGE on the pipeline. Set to null to skip."
  type        = string
  default     = null
}

variable "additional_access_control_list" {
  description = "Additional ACL entries for the pipeline"
  type = list(object({
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
    permission_level       = string
  }))
  default = []
}

variable "name" {
  description = "Name of the pipeline"
  type        = string
}

variable "storage" {
  description = "Storage location for the pipeline"
  type        = string
  default     = null
}

variable "target" {
  description = "Target schema for the pipeline"
  type        = string
  default     = null
}

variable "catalog" {
  description = "Target catalog for Unity Catalog pipelines"
  type        = string
  default     = null
}

variable "clusters" {
  description = "List of cluster configurations"
  type        = list(any)
  default     = []
}

variable "configuration" {
  description = "Pipeline configuration settings"
  type        = map(string)
  default     = {}
}

variable "continuous" {
  description = "Whether the pipeline runs continuously"
  type        = bool
  default     = false
}

variable "development" {
  description = "Whether this is a development pipeline"
  type        = bool
  default     = false
}

variable "edition" {
  description = "Pipeline edition (CORE, PRO, ADVANCED)"
  type        = string
  default     = "ADVANCED"
}

variable "channel" {
  description = "Release channel (CURRENT or PREVIEW)"
  type        = string
  default     = "CURRENT"
}

variable "photon" {
  description = "Enable Photon acceleration"
  type        = bool
  default     = true
}

variable "serverless" {
  description = "Use serverless compute"
  type        = bool
  default     = false
}

variable "allow_duplicate_names" {
  description = "Allow duplicate pipeline names"
  type        = bool
  default     = false
}

variable "libraries" {
  description = "List of libraries"
  type        = list(any)
  default     = []
}

variable "notifications" {
  description = "List of notification configurations"
  type = list(object({
    email_recipients = list(string)
    alerts           = list(string)
  }))
  default = []
}
