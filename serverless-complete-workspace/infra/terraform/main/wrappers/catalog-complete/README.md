# Wrapper: Catalog Complete (End-to-End)

## Purpose
Creates a complete Unity Catalog setup including all dependent resources:
- KMS key for catalog storage encryption
- S3 bucket for catalog data
- IAM role and policy for cross-account S3 access
- Storage credential
- External location
- Catalog with owner group
- Schema creation with permissions
- Grants for catalog and schema levels

## Required Inputs
| Variable | Description |
|---|---|
| `databricks_account_id` | Databricks account ID |
| `workspace_id` | Databricks workspace ID |
| `name_prefix` | Prefix for resource names (e.g. workspace name) |

## Optional Inputs
| Variable | Default | Description |
|---|---|---|
| `catalog_owner` | `"account users"` | Owner of the catalog |
| `catalog_isolation_mode` | `"ISOLATED"` | Isolation mode (ISOLATED/OPEN) |
| `force_destroy` | `false` | Allow force destroy |
| `schemas` | `{}` | Map of schema configs with permissions |
| `permissions` | `{groups={},service_principals={}}` | Catalog-level permissions |
| `tags` | `{}` | AWS resource tags |

## Example tfvars
See `examples/terraform.tfvars`

## Execution Order (Dependency Flow)
1. KMS key created for encryption
2. Storage credential created (returns external_id)
3. IAM role + policy created with trust policy using external_id
4. S3 bucket created with KMS encryption
5. IAM propagation wait (60s)
6. External location created pointing to S3
7. Catalog created with storage root
8. Default namespace set
9. Catalog-level grants applied
10. Schemas created
11. Schema-level grants applied

## Modules Used
- `modules/catalog-creation` (orchestrates all dependencies)
  - `terraform-aws-modules/kms/aws`
  - `terraform-aws-modules/iam/aws`
  - `terraform-aws-modules/s3-bucket/aws`
