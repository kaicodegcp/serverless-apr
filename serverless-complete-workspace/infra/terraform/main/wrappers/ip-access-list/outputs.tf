output "id" {
  description = "The ID of the IP access list"
  value       = module.ip_access_list.id
}

output "label" {
  description = "The label of the IP access list"
  value       = module.ip_access_list.label
}

output "list_type" {
  description = "The type of the IP access list"
  value       = module.ip_access_list.list_type
}
