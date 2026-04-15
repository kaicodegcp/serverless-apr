# Wrapper: Add Service Principal to Workspace

## Purpose
Creates a Databricks service principal and assigns it to a workspace with configurable permissions.

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `display_name` | Display name for the service principal |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `workspace_id` | `null` | Workspace ID to assign SP to (skip if null) |
| `workspace_permissions` | `["USER"]` | Workspace permission level |
| `application_id` | `null` | UUID of the SP (auto-generated if null) |
| `active` | `true` | Whether the SP is active |
| `allow_cluster_create` | `false` | Allow cluster creation |
| `allow_instance_pool_create` | `false` | Allow instance pool creation |
| `databricks_sql_access` | `false` | Allow SQL access |
| `workspace_access` | `true` | Allow workspace access |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order
1. Service principal is created via the `service-principal` module
2. SP is assigned to the workspace via `databricks_mws_permission_assignment`

## Modules Used
- `modules/service-principal`
