# Wrapper: SQL Warehouse

## Purpose
Creates a Databricks SQL Warehouse with owner group permissions and optional additional ACLs.

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `name` | SQL warehouse name |
| `cluster_size` | Cluster size |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `owner_group_name` | `null` | Group that gets CAN_MANAGE |
| `warehouse_type` | `"PRO"` | Warehouse type (PRO, CLASSIC) |
| `enable_serverless_compute` | `true` | Enable serverless |
| `auto_stop_mins` | `120` | Auto-stop timeout |
| `additional_access_control_list` | `[]` | Additional ACL entries |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order
1. SQL warehouse is created via `sql-warehouse` module
2. Permissions are set via `permissions` module

## Modules Used
- `modules/sql-warehouse`
- `modules/permissions`
