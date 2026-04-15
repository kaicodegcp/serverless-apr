# =============================================================================
# Network Connectivity Configuration (NCC) Module - Variables
# =============================================================================
# Creates a Databricks MWS Network Connectivity Config for serverless compute
# egress control. Use with databricks_mws_ncc_binding to attach to a workspace.
# =============================================================================

variable "name" {
  description = "Name of the Network Connectivity Config in the Databricks account"
  type        = string
}

variable "region" {
  description = "AWS region for the NCC. NCCs can only be referenced by workspaces in the same region."
  type        = string
}

# -----------------------------------------------------------------------------
# Private endpoint rule for AWS Network Load Balancer (optional)
# -----------------------------------------------------------------------------
# When you expose an internal NLB via an AWS VPC endpoint service, use this to
# add a private endpoint rule so serverless compute can reach resources behind the NLB.
# Create the NLB and VPC endpoint service in AWS first; then set the endpoint
# service name and the FQDNs that resolve via that NLB.
# -----------------------------------------------------------------------------

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
