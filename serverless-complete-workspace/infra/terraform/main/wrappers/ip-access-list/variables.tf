variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "list_type" {
  description = "Type of IP access list (ALLOW or BLOCK)"
  type        = string
}

variable "label" {
  description = "Label for the IP access list"
  type        = string
}

variable "ip_addresses" {
  description = "List of IP addresses or CIDR blocks"
  type        = list(string)
}

variable "enabled" {
  description = "Whether the IP access list is enabled"
  type        = bool
  default     = true
}
