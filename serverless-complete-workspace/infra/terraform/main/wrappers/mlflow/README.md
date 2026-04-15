# Wrapper: MLflow Experiment

## Purpose
Creates a Databricks MLflow experiment with owner group permissions and optional additional ACLs.

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `name` | Experiment name (workspace path) |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `owner_group_name` | `null` | Group that gets CAN_MANAGE |
| `artifact_location` | `null` | Artifact storage location |
| `description` | `null` | Experiment description |
| `additional_access_control_list` | `[]` | Additional ACL entries |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order
1. MLflow experiment is created via `mlflow-experiment` module
2. Permissions are set via `permissions` module

## Modules Used
- `modules/mlflow-experiment`
- `modules/permissions`
