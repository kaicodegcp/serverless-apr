output "id" {
  description = "The ID of the group"
  value       = module.group.id
}

output "display_name" {
  description = "The display name of the group"
  value       = module.group.display_name
}

output "workspace_assignment_id" {
  description = "The ID of the workspace assignment"
  value       = length(databricks_mws_permission_assignment.group_workspace) > 0 ? databricks_mws_permission_assignment.group_workspace[0].id : null
}
