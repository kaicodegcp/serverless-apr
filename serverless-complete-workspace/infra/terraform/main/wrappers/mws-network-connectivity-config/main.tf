# Wrapper: mws-network-connectivity-config
module "mws_network_connectivity_config" {
  source = "../../modules/mws-network-connectivity-config"

  name = var.name
  region = var.region
  nlb_vpc_endpoint_service_name = var.nlb_vpc_endpoint_service_name
  nlb_domain_names = var.nlb_domain_names
}
