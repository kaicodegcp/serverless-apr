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

output "workspace_assignment_id" {
  description = "The ID of the workspace assignment"
  value       = length(databricks_mws_permission_assignment.sp_workspace) > 0 ? databricks_mws_permission_assignment.sp_workspace[0].id : null
}
