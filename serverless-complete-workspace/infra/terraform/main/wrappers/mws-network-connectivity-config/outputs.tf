output "network_connectivity_config_id" {
  description = "Canonical unique identifier of the Network Connectivity Config in the Databricks account"
  value       = module.mws_network_connectivity_config.network_connectivity_config_id
}

output "id" {
  description = "Same as network_connectivity_config_id (convenience alias)"
  value       = module.mws_network_connectivity_config.id
}

output "egress_config" {
  description = "Computed egress rules from Databricks (e.g. aws_stable_ip_rule.cidr_blocks for AWS). Use for firewall allowlisting; cannot be set via Terraform."
  value       = module.mws_network_connectivity_config.egress_config
}

output "nlb_private_endpoint_rule_id" {
  description = "ID of the private endpoint rule for the AWS NLB, when nlb_vpc_endpoint_service_name and nlb_domain_names are set"
  value       = module.mws_network_connectivity_config.nlb_private_endpoint_rule_id
}

output "nlb_private_endpoint_connection_state" {
  description = "Connection state of the NLB private endpoint rule (e.g. ESTABLISHED, PENDING). Rule is effective when ESTABLISHED."
  value       = module.mws_network_connectivity_config.nlb_private_endpoint_connection_state
}
