variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "name" {
  description = "Name of the Network Connectivity Config in the Databricks account"
  type        = string
}

variable "region" {
  description = "AWS region for the NCC. NCCs can only be referenced by workspaces in the same region."
  type        = string
}

variable "nlb_vpc_endpoint_service_name" {
  description = "AWS VPC endpoint service name for the Network Load Balancer (e.g. com.amazonaws.vpce.us-west-2.vpce-svc-xxxxxxxx). Set with nlb_domain_names to create a private endpoint rule."
  type        = string
  default     = null
}

variable "nlb_domain_names" {
  description = "List of FQDNs reachable via the NLB (e.g. internal API hostnames). Required when nlb_vpc_endpoint_service_name is set."
  type        = list(string)
  default     = []
}
