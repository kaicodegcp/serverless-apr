output "id" {
  description = "The ID of the VPC endpoint"
  value       = module.mws_vpc_endpoint.id
}

output "vpc_endpoint_id" {
  description = "The VPC endpoint ID"
  value       = module.mws_vpc_endpoint.vpc_endpoint_id
}

output "vpc_endpoint_name" {
  description = "The name of the VPC endpoint"
  value       = module.mws_vpc_endpoint.vpc_endpoint_name
}
