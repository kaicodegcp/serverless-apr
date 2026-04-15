output "id" {
  description = "The ID of the notebook"
  value       = databricks_notebook.this.id
}

output "url" {
  description = "The URL of the notebook"
  value       = databricks_notebook.this.url
}

output "path" {
  description = "The path of the notebook"
  value       = databricks_notebook.this.path
}

output "object_id" {
  description = "The object ID of the notebook"
  value       = databricks_notebook.this.object_id
}
