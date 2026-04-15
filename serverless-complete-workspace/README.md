# Serverless Complete Workspace

End-to-end **Terraform + Terratest** implementation for provisioning a **Databricks serverless workspace on AWS** with Unity Catalog, customer-managed keys, and optional service principal.

Includes **18 individual wrapper modules** for isolated execution, testing, and reuse.

---

## Folder Structure

```
serverless-complete-workspace/
├── .gitignore
├── pipeline.yaml
├── README.md
├── infra/
│   └── terraform/
│       └── main/
│           ├── main.tf                          # Root module — calls complete-workspace-serverless
│           ├── variables.tf / outputs.tf / versions.tf / providers.tf / locals.tf / data.tf
│           ├── modules/                         # Reusable child modules (from reference zip)
│           │   ├── catalog/
│           │   ├── catalog-creation/
│           │   ├── complete-workspace-serverless/
│           │   ├── external-location/
│           │   ├── group/
│           │   ├── group-member/
│           │   ├── ip-access-list/
│           │   ├── metastore/
│           │   ├── mws-credentials/
│           │   ├── mws-network-connectivity-config/
│           │   ├── mws-networks/
│           │   ├── mws-storage-configuration/
│           │   ├── mws-vpc-endpoint/
│           │   ├── permissions/
│           │   ├── schema/
│           │   ├── service-principal/
│           │   ├── storage-credential/
│           │   ├── user/
│           │   └── workspace-conf/
│           ├── wrappers/                        # Individually executable wrappers
│           │   ├── <module-name>/
│           │   │   ├── main.tf
│           │   │   ├── variables.tf
│           │   │   ├── outputs.tf
│           │   │   ├── versions.tf
│           │   │   ├── providers.tf
│           │   │   └── aws-SE-99d097-databricks/us-east-1/<name>.auto.tfvars
│           │   └── ... (18 wrappers)
│           └── aws-SE-99d097-databricks/
│               └── us-east-1/
│                   └── terraform-complete-workspace-serverless.auto.tfvars
├── test/
│   └── terratest/
│       ├── README.md
│       ├── complete_workspace_serverless/       # Existing end-to-end test
│       └── <module-name>/                       # Per-wrapper Terratest (18 packages)
│           ├── <module_name>_test.go
│           ├── go.mod
│           ├── test.sh
│           └── README.md
└── docs/
    └── uml/
        ├── 01-aws-resources-flow.png            # End-to-end diagrams
        ├── ... (7 diagrams)
        └── wrappers/                            # Per-wrapper diagrams (18 PNGs)
            ├── mws-storage-configuration.png
            ├── ...
            └── ip-access-list.png
```

---

## Module Tracker

| # | Module | Type | Purpose | Inputs | Outputs | Dep Order | Terratest Path | UML PNG |
|---|--------|------|---------|--------|---------|-----------|----------------|---------|
| 1 | `mws-storage-configuration` | Databricks | Register S3 bucket as MWS storage config | `databricks_account_id`, `storage_configuration_name`, `bucket_name` | `storage_configuration_id`, `storage_configuration_name`, `id` | 3 | `test/terratest/mws-storage-configuration/` | `docs/uml/wrappers/mws-storage-configuration.png` |
| 2 | `mws-credentials` | Databricks | Register cross-account IAM role as MWS credentials | `databricks_account_id`, `credentials_name`, `role_arn` | `credentials_id`, `credentials_name`, `id` | 2 | `test/terratest/mws-credentials/` | `docs/uml/wrappers/mws-credentials.png` |
| 3 | `mws-networks` | Databricks | Register VPC as MWS network configuration | `databricks_account_id`, `network_name`, `vpc_id`, `subnet_ids`, `security_group_ids` | `network_id`, `network_name`, `vpc_status`, `id` | 4 | `test/terratest/mws-networks/` | `docs/uml/wrappers/mws-networks.png` |
| 4 | `mws-vpc-endpoint` | Databricks | Register VPC endpoint for PrivateLink | `databricks_account_id`, `endpoint_name`, `vpc_endpoint_id`, `region`, `aws_account_id` | `mws_vpc_endpoint_id`, `id` | 5 | `test/terratest/mws-vpc-endpoint/` | `docs/uml/wrappers/mws-vpc-endpoint.png` |
| 5 | `mws-network-connectivity-config` | Databricks | Network connectivity config for serverless | `databricks_account_id`, `name`, `region` | `network_connectivity_config_id`, `id` | 6 | `test/terratest/mws-network-connectivity-config/` | `docs/uml/wrappers/mws-network-connectivity-config.png` |
| 6 | `metastore` | Databricks | Create or manage Unity Catalog metastore | `name`, `storage_root`, `owner`, `region`, `force_destroy` | `metastore_id`, `name`, `id` | 8 | `test/terratest/metastore/` | `docs/uml/wrappers/metastore.png` |
| 7 | `catalog` | Databricks | Create Unity Catalog catalog | `name`, `storage_root`, `owner`, `force_destroy`, `comment`, `properties` | `id`, `name` | 9 | `test/terratest/catalog/` | `docs/uml/wrappers/catalog.png` |
| 8 | `catalog-creation` | Databricks | Create catalog with nested schemas | `catalog_name`, `schemas`, `storage_root`, `owner` | `catalog_id`, `catalog_name`, `schema_ids` | 10 | `test/terratest/catalog-creation/` | `docs/uml/wrappers/catalog-creation.png` |
| 9 | `schema` | Databricks | Create Unity Catalog schema | `name`, `catalog_name`, `owner`, `comment`, `properties` | `id`, `name` | 11 | `test/terratest/schema/` | `docs/uml/wrappers/schema.png` |
| 10 | `service-principal` | Databricks | Create service principal for automation | `display_name`, `allow_cluster_create`, `active` | `id`, `application_id`, `display_name` | 12 | `test/terratest/service-principal/` | `docs/uml/wrappers/service-principal.png` |
| 11 | `group` | Databricks | Create Databricks group | `display_name`, `allow_cluster_create` | `id`, `display_name` | 13 | `test/terratest/group/` | `docs/uml/wrappers/group.png` |
| 12 | `group-member` | Databricks | Manage group membership | `group_id`, `member_id` | `id` | 14 | `test/terratest/group-member/` | `docs/uml/wrappers/group-member.png` |
| 13 | `user` | Databricks | Create Databricks user | `user_name`, `display_name`, `active` | `id`, `user_name` | 15 | `test/terratest/user/` | `docs/uml/wrappers/user.png` |
| 14 | `storage-credential` | Databricks | Create storage credential for external access | `name`, `aws_iam_role_arn`, `comment`, `owner` | `id`, `name` | 16 | `test/terratest/storage-credential/` | `docs/uml/wrappers/storage-credential.png` |
| 15 | `external-location` | Databricks | Create external location | `name`, `url`, `credential_name`, `owner`, `comment` | `id`, `name`, `url` | 17 | `test/terratest/external-location/` | `docs/uml/wrappers/external-location.png` |
| 16 | `permissions` | Databricks | Manage object-level permissions | `object_type`, `object_id`, `access_control` | `id`, `object_type`, `object_id` | 18 | `test/terratest/permissions/` | `docs/uml/wrappers/permissions.png` |
| 17 | `workspace-conf` | Databricks | Configure workspace settings (SRA-aligned) | `enable_ip_access_lists`, `max_token_lifetime_days`, `disable_legacy_dbfs`, ... | config (applied settings) | 7 | `test/terratest/workspace-conf/` | `docs/uml/wrappers/workspace-conf.png` |
| 18 | `ip-access-list` | Databricks | Create IP access list | `list_type`, `label`, `ip_addresses`, `enabled` | `id`, `label`, `list_type` | 19 | `test/terratest/ip-access-list/` | `docs/uml/wrappers/ip-access-list.png` |

### Dependency Order (recommended provisioning sequence)

```
1. AWS prerequisites (IAM roles, S3 buckets, KMS keys, VPCs)
2. mws-credentials         → Register cross-account role
3. mws-storage-configuration → Register root storage bucket
4. mws-networks             → Register VPC/subnets (custom VPC only)
5. mws-vpc-endpoint         → Register VPC endpoints (PrivateLink only)
6. mws-network-connectivity-config → Serverless NCC
7. workspace-conf           → Workspace security settings
8. metastore                → Create/configure Unity Catalog metastore
9. catalog                  → Create catalog
10. catalog-creation         → Create catalog with schemas
11. schema                   → Create individual schemas
12. service-principal        → Create service principals
13. group                    → Create groups
14. group-member             → Assign members to groups
15. user                     → Create users
16. storage-credential       → Create storage credentials
17. external-location        → Create external locations
18. permissions              → Set object permissions
19. ip-access-list           → Configure IP restrictions
```

---

## Prerequisites

- **Terraform** >= 1.5.0
- **Go** >= 1.21 (for Terratest)
- **AWS CLI** configured (or instance profile with sufficient permissions)
- **Databricks Account** with:
  - An existing Unity Catalog metastore
  - A service principal with account-admin privileges (for MWS operations)

---

## Required Environment Variables

All authentication is environment-variable-first. **No secrets in code or tfvars.**

```bash
# --- Databricks Account-Level Auth ---
export DATABRICKS_HOST="https://accounts.cloud.databricks.com"
export DATABRICKS_ACCOUNT_ID="<your-databricks-account-id>"
export DATABRICKS_CLIENT_ID="<service-principal-client-id>"
export DATABRICKS_CLIENT_SECRET="<service-principal-client-secret>"

# Wire account ID into Terraform variable automatically
export TF_VAR_databricks_account_id="$DATABRICKS_ACCOUNT_ID"

# --- AWS Auth ---
export AWS_ACCESS_KEY_ID="<your-aws-access-key>"
export AWS_SECRET_ACCESS_KEY="<your-aws-secret-key>"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## How to Run Complete Workspace (End-to-End)

```bash
cd serverless-complete-workspace/infra/terraform/main
terraform init
terraform validate
terraform plan \
  -var-file="aws-SE-99d097-databricks/us-east-1/terraform-complete-workspace-serverless.auto.tfvars"
```

## How to Run Individual Wrappers

Each wrapper is independently executable:

```bash
# Example: mws-storage-configuration
cd serverless-complete-workspace/infra/terraform/main/wrappers/mws-storage-configuration
terraform init
terraform validate
terraform plan
# terraform apply  (requires live credentials)
```

All wrappers auto-load their tfvars from `aws-SE-99d097-databricks/us-east-1/`.

---

## How to Run Terratest

### End-to-End Test

```bash
cd serverless-complete-workspace/test/terratest/complete_workspace_serverless
chmod +x test.sh
./test.sh
```

### Per-Wrapper Tests

```bash
# Example: mws-storage-configuration
cd serverless-complete-workspace/test/terratest/mws-storage-configuration
chmod +x test.sh
./test.sh
```

### Keep Resources (skip destroy)

```bash
export KEEP_RESOURCES=true
./test.sh
```

---

## UML Diagrams

### End-to-End Architecture Diagrams

Located in `docs/uml/`:

| Diagram | File |
|---------|------|
| AWS Resources Flow | `01-aws-resources-flow.png` |
| Databricks Account-Level Flow | `02-databricks-account-level-flow.png` |
| Workspace Serverless Flow | `03-workspace-serverless-flow.png` |
| Unity Catalog Flow | `04-unity-catalog-flow.png` |
| Identity / Service Principal / Access Flow | `05-identity-access-flow.png` |
| End-to-End Provisioning Flow | `06-end-to-end-provisioning-flow.png` |
| Test Execution Flow (Terraform + Terratest) | `07-test-execution-flow.png` |

### Per-Wrapper Module Diagrams

Located in `docs/uml/wrappers/`:

| Module | Diagram |
|--------|---------|
| mws-storage-configuration | `mws-storage-configuration.png` |
| mws-credentials | `mws-credentials.png` |
| mws-networks | `mws-networks.png` |
| mws-vpc-endpoint | `mws-vpc-endpoint.png` |
| mws-network-connectivity-config | `mws-network-connectivity-config.png` |
| metastore | `metastore.png` |
| catalog | `catalog.png` |
| catalog-creation | `catalog-creation.png` |
| schema | `schema.png` |
| service-principal | `service-principal.png` |
| group | `group.png` |
| group-member | `group-member.png` |
| user | `user.png` |
| storage-credential | `storage-credential.png` |
| external-location | `external-location.png` |
| permissions | `permissions.png` |
| workspace-conf | `workspace-conf.png` |
| ip-access-list | `ip-access-list.png` |

Each diagram shows:
- **Inputs** (variables, env vars)
- **Provider/auth** flow
- **Module/resource** creation
- **Outputs** (Terraform outputs)
- **Upstream/downstream** dependencies

---

## Assumptions and Limitations

1. **Module source code**: All individual modules are sourced directly from `databricks-all-modules-main_apr.zip` (`modules/` path) to maintain consistency with the reference implementation.
2. **Serverless mode**: The complete workspace uses `compute_mode = SERVERLESS`. Individual wrappers can be used for both serverless and classic flows.
3. **Existing metastore**: The complete workspace module expects an existing Unity Catalog metastore in the target region.
4. **Databricks AWS account ID**: Defaults to `414351767826` (Databricks commercial). Update if using a different region or account type.
5. **No VPC/PrivateLink for serverless**: Serverless workspaces do not require customer-managed VPCs. The `mws-networks` and `mws-vpc-endpoint` wrappers are provided for classic workspace flows.
6. **Environment-variable-first**: All authentication uses environment variables. No secrets in code.
7. **Provider version**: Requires `databricks/databricks >= 1.80.0` for `compute_mode = SERVERLESS`.
8. **Wrappers are independently deployable**: Each wrapper has its own `providers.tf`, `versions.tf`, and sample tfvars.
9. **Terratest follows reference pattern**: Test structure matches `mws-storage-configuration-se-testing-with-terratest-v2.zip` conventions.
10. **Force destroy**: Set `force_destroy = true` only for test/disposable resources.
