# Wrapper: Notebook

## Purpose
Creates a Databricks notebook with owner group permissions and optional additional ACLs.

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `path` | Workspace path for the notebook |
| `language` | Notebook language (PYTHON, SCALA, SQL, R) |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `owner_group_name` | `null` | Group that gets CAN_MANAGE |
| `format` | `"SOURCE"` | Notebook format |
| `content_base64` | `null` | Base64-encoded content |
| `notebook_source` | `null` | Local file path |
| `additional_access_control_list` | `[]` | Additional ACL entries |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order
1. Notebook is created via `notebook` module
2. Permissions are set via `permissions` module

## Modules Used
- `modules/notebook`
- `modules/permissions`
