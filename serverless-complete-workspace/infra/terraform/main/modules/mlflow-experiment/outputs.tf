output "id" {
  description = "The ID of the MLflow experiment"
  value       = databricks_mlflow_experiment.this.id
}

output "name" {
  description = "The name of the MLflow experiment"
  value       = databricks_mlflow_experiment.this.name
}
