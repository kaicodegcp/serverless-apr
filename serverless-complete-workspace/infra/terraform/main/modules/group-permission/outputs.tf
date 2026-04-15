output "workspace_assignment_id" {
  description = "ID of the workspace permission assignment"
  value       = length(databricks_mws_permission_assignment.workspace) > 0 ? databricks_mws_permission_assignment.workspace[0].id : null
}

output "catalog_grant_ids" {
  description = "Map of catalog grant IDs"
  value       = { for k, v in databricks_grant.catalog : k => v.id }
}

output "schema_grant_ids" {
  description = "Map of schema grant IDs"
  value       = { for k, v in databricks_grant.schema : k => v.id }
}

output "table_grant_ids" {
  description = "Map of table grant IDs"
  value       = { for k, v in databricks_grant.table : k => v.id }
}
