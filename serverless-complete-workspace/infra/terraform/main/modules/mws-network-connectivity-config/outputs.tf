# =============================================================================
# Network Connectivity Configuration - Outputs
# =============================================================================

output "network_connectivity_config_id" {
  description = "Canonical unique identifier of the Network Connectivity Config in the Databricks account"
  value       = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
}

output "id" {
  description = "Same as network_connectivity_config_id (convenience alias)"
  value       = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
}

# Computed egress info (read-only; cannot be set via this resource)
output "egress_config" {
  description = "Computed egress rules from Databricks (e.g. aws_stable_ip_rule.cidr_blocks for AWS). Use for firewall allowlisting; cannot be set via Terraform."
  value       = databricks_mws_network_connectivity_config.this.egress_config
}

# NLB private endpoint rule (when created)
output "nlb_private_endpoint_rule_id" {
  description = "ID of the private endpoint rule for the AWS NLB, when nlb_vpc_endpoint_service_name and nlb_domain_names are set"
  value       = length(databricks_mws_ncc_private_endpoint_rule.nlb) > 0 ? databricks_mws_ncc_private_endpoint_rule.nlb[0].rule_id : null
}

output "nlb_private_endpoint_connection_state" {
  description = "Connection state of the NLB private endpoint rule (e.g. ESTABLISHED, PENDING). Rule is effective when ESTABLISHED."
  value       = length(databricks_mws_ncc_private_endpoint_rule.nlb) > 0 ? databricks_mws_ncc_private_endpoint_rule.nlb[0].connection_state : null
}
