output "id" {
  description = "The ID of the SQL warehouse"
  value       = databricks_sql_endpoint.this.id
}

output "name" {
  description = "The name of the SQL warehouse"
  value       = databricks_sql_endpoint.this.name
}

output "data_source_id" {
  description = "The data source ID of the SQL warehouse"
  value       = databricks_sql_endpoint.this.data_source_id
}

output "jdbc_url" {
  description = "The JDBC URL of the SQL warehouse"
  value       = databricks_sql_endpoint.this.jdbc_url
}

output "odbc_params" {
  description = "The ODBC params of the SQL warehouse"
  value       = databricks_sql_endpoint.this.odbc_params
}
