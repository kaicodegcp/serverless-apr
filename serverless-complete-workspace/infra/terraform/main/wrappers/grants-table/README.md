# Wrapper: Grants for Table

## Purpose
Creates Unity Catalog grants for tables. Supports granting privileges to groups, users, and service principals.

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `grant_list` | `[]` | List of grant objects with resource_type, resource_name, principal, privileges |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order
1. Grants are applied via the `grants` module using `databricks_grant` resources

## Modules Used
- `modules/grants`
