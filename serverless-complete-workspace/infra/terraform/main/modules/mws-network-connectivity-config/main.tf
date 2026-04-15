# =============================================================================
# Databricks Network Connectivity Configuration (NCC)
# =============================================================================
# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_network_connectivity_config
#
# Note: The Terraform resource only supports name and region. There is no
# egress_policy or egress_config argument; egress rules are computed by
# Databricks and exported as the egress_conf attribute (see outputs).
# =============================================================================

resource "databricks_mws_network_connectivity_config" "this" {
  name   = var.name
  region = var.region
}

# =============================================================================
# Private endpoint rule for AWS Network Load Balancer
# =============================================================================
# Allows serverless compute to reach resources behind an internal NLB exposed
# via an AWS VPC endpoint service. Set nlb_vpc_endpoint_service_name and
# nlb_domain_names to create this rule.
# connection_state is ignored so Databricks can transition CREATING -> ESTABLISHED
# without Terraform sending an update (API requires an update mask).
# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_ncc_private_endpoint_rule
# =============================================================================

resource "databricks_mws_ncc_private_endpoint_rule" "nlb" {
  count    = var.nlb_vpc_endpoint_service_name != null && length(var.nlb_domain_names) > 0 ? 1 : 0

  network_connectivity_config_id = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
  endpoint_service               = var.nlb_vpc_endpoint_service_name
  domain_names                   = var.nlb_domain_names

  lifecycle {
    ignore_changes = [connection_state]
  }
}
