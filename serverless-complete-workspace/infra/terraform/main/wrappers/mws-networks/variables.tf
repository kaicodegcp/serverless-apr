variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "account_id" {
  description = "Databricks account ID"
  type        = string
}

variable "network_name" {
  description = "Name of the network configuration"
  type        = string
}

variable "vpc_id" {
  description = "AWS VPC ID (3.1: Use customer-managed VPC for security controls)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs (at least 2 required)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "vpc_endpoints" {
  description = "VPC endpoints for PrivateLink"
  type        = object({
}
