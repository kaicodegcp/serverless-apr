output "id" {
  description = "The ID of the network configuration"
  value       = module.mws_networks.id
}

output "network_id" {
  description = "The network ID"
  value       = module.mws_networks.network_id
}

output "network_name" {
  description = "The name of the network configuration"
  value       = module.mws_networks.network_name
}

output "vpc_id" {
  description = "The VPC ID"
  value       = module.mws_networks.vpc_id
}
