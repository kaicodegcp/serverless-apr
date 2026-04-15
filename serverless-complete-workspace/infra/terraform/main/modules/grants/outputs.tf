output "grant_ids" {
  description = "Map of grant resource IDs"
  value       = { for k, v in databricks_grant.this : k => v.id }
}
