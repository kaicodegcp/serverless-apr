output "id" {
  description = "The ID of the SQL warehouse"
  value       = module.sql_warehouse.id
}

output "name" {
  description = "The name of the SQL warehouse"
  value       = module.sql_warehouse.name
}

output "data_source_id" {
  description = "The data source ID"
  value       = module.sql_warehouse.data_source_id
}

output "jdbc_url" {
  description = "The JDBC URL"
  value       = module.sql_warehouse.jdbc_url
}
