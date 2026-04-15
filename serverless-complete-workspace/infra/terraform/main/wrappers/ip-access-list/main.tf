# Wrapper: ip-access-list
module "ip_access_list" {
  source = "../../modules/ip-access-list"

  list_type = var.list_type
  label = var.label
  ip_addresses = var.ip_addresses
  enabled = var.enabled
}
