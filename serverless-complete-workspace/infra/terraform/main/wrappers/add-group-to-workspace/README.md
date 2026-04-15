# Wrapper: Add Group to Workspace

## Purpose
Creates a Databricks group and assigns it to a workspace with configurable permissions.

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `display_name` | Display name for the group |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `workspace_id` | `null` | Workspace ID to assign group to (skip if null) |
| `workspace_permissions` | `["USER"]` | Workspace permission level |
| `allow_cluster_create` | `false` | Allow cluster creation |
| `databricks_sql_access` | `false` | Allow SQL access |
| `workspace_access` | `true` | Allow workspace access |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order
1. Group is created via the `group` module
2. Group is assigned to the workspace via `databricks_mws_permission_assignment`

## Modules Used
- `modules/group`
