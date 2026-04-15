output "id" {
  description = "The ID of the service principal"
  value       = module.service_principal.id
}

output "application_id" {
  description = "The application ID of the service principal"
  value       = module.service_principal.application_id
}

output "display_name" {
  description = "The display name of the service principal"
  value       = module.service_principal.display_name
}

output "acl_principal_id" {
  description = "The ACL principal ID of the service principal"
  value       = module.service_principal.acl_principal_id
}
