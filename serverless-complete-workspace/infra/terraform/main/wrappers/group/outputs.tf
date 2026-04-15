output "id" {
  description = "The ID of the group"
  value       = module.group.id
}

output "display_name" {
  description = "The display name of the group"
  value       = module.group.display_name
}

output "acl_principal_id" {
  description = "The ACL principal ID of the group"
  value       = module.group.acl_principal_id
}
