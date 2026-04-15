# Wrapper: Group Permission

## Purpose
Assigns permissions to a Databricks group across multiple scopes:
- Account-level workspace assignment
- Catalog-level grants
- Schema-level grants
- Table-level grants

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `group_name` | Display name of the group |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `group_id` | `null` | Numeric group ID (required for workspace assignment) |
| `workspace_id` | `null` | Workspace ID (skip assignment if null) |
| `workspace_permissions` | `["USER"]` | Workspace permission level |
| `catalog_grants` | `{}` | Map of catalog => privileges |
| `schema_grants` | `{}` | Map of schema => privileges |
| `table_grants` | `{}` | Map of table => privileges |

## Persona Examples
See `examples/` directory for per-persona tfvars:
- `workspace-admin-sp.tfvars` - Full manage rights
- `ops-monitoring.tfvars` - Read/view rights
- `data-engineering.tfvars` - Run/write rights
- `analyst.tfvars` - Read/run rights
- `deployer-cicd.tfvars` - Manage/run rights
- `PERMISSION_MATRIX.md` - Full permission matrix reference

## Execution Order
1. Workspace assignment (if workspace_id provided)
2. Catalog grants
3. Schema grants
4. Table grants

## Modules Used
- `modules/group-permission`
