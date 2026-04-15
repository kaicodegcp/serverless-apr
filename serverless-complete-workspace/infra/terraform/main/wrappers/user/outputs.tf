output "id" {
  description = "The ID of the user"
  value       = module.user.id
}

output "user_name" {
  description = "The username of the user"
  value       = module.user.user_name
}

output "acl_principal_id" {
  description = "The ACL principal ID of the user"
  value       = module.user.acl_principal_id
}

output "home" {
  description = "Home directory path for the user"
  value       = module.user.home
}
