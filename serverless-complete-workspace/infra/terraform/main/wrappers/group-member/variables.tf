variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "group_id" {
  description = "ID of the group"
  type        = string
}

variable "member_id" {
  description = "ID of the member (user or service principal) to add to the group"
  type        = string
}
