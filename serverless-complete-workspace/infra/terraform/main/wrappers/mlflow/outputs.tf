output "id" {
  description = "The ID of the MLflow experiment"
  value       = module.mlflow_experiment.id
}

output "name" {
  description = "The name of the MLflow experiment"
  value       = module.mlflow_experiment.name
}
