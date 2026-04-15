output "workspace_assignment_id" {
  description = "ID of the workspace permission assignment"
  value       = module.group_permission.workspace_assignment_id
}

output "catalog_grant_ids" {
  description = "Map of catalog grant IDs"
  value       = module.group_permission.catalog_grant_ids
}

output "schema_grant_ids" {
  description = "Map of schema grant IDs"
  value       = module.group_permission.schema_grant_ids
}

output "table_grant_ids" {
  description = "Map of table grant IDs"
  value       = module.group_permission.table_grant_ids
}
