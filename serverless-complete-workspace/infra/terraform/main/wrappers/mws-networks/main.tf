# Wrapper: mws-networks
module "mws_networks" {
  source = "../../modules/mws-networks"

  account_id = var.account_id
  network_name = var.network_name
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  security_group_ids = var.security_group_ids
  vpc_endpoints = var.vpc_endpoints
}
