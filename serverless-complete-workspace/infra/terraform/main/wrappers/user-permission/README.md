# Wrapper: User Permission

## Purpose
Assigns permissions to a Databricks user across multiple scopes:
- Account-level workspace assignment
- Catalog-level grants
- Schema-level grants
- Table-level grants

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `user_name` | Email or username of the user |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `user_id` | `null` | Numeric user ID (required for workspace assignment) |
| `workspace_id` | `null` | Workspace ID (skip assignment if null) |
| `workspace_permissions` | `["USER"]` | Workspace permission level |
| `catalog_grants` | `{}` | Map of catalog => privileges |
| `schema_grants` | `{}` | Map of schema => privileges |
| `table_grants` | `{}` | Map of table => privileges |

## Persona Examples
See `examples/` directory:
- `admin-user.tfvars` - Full admin rights
- `analyst-user.tfvars` - Read/run rights

## Execution Order
1. Workspace assignment (if workspace_id provided)
2. Catalog grants
3. Schema grants
4. Table grants

## Modules Used
- `modules/user-permission`
