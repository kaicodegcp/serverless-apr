# Wrapper: Pipeline (DLT)

## Purpose
Creates a Delta Live Tables pipeline with owner group permissions and optional additional ACLs.

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `name` | Pipeline name |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `owner_group_name` | `null` | Group that gets CAN_MANAGE |
| `catalog` | `null` | Target catalog for UC pipelines |
| `target` | `null` | Target schema |
| `serverless` | `false` | Use serverless compute |
| `libraries` | `[]` | Pipeline libraries |
| `additional_access_control_list` | `[]` | Additional ACL entries |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order
1. Pipeline is created via `pipeline` module
2. Permissions are set via `permissions` module

## Modules Used
- `modules/pipeline`
- `modules/permissions`
