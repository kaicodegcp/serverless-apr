# Wrapper: mlflow
# Creates an MLflow experiment with owner group permissions

module "mlflow_experiment" {
  source = "../../modules/mlflow-experiment"

  name              = var.name
  artifact_location = var.artifact_location
  description       = var.description
}

# Set permissions on the experiment for the owner group
module "experiment_permissions" {
  count  = var.owner_group_name != null ? 1 : 0
  source = "../../modules/permissions"

  experiment_id = module.mlflow_experiment.id
  access_control_list = concat(
    var.owner_group_name != null ? [{
      group_name             = var.owner_group_name
      user_name              = null
      service_principal_name = null
      permission_level       = "CAN_MANAGE"
    }] : [],
    var.additional_access_control_list
  )
}
