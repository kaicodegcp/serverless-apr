# complete_workspace_serverless Terratest

This suite runs Terraform against the root module:

- `infra/terraform/main`

and uses the SE example tfvars:

- `infra/terraform/main/aws-SE-99d097-databricks/us-east-1/terraform-complete-workspace-serverless.auto.tfvars`

## Prereqs

- Go >= 1.21
- Terraform >= 1.5.0 available in PATH
- AWS credentials exported as env vars or via instance profile
- Databricks **Account** auth exported as env vars:

```bash
export DATABRICKS_HOST="https://accounts.cloud.databricks.com"
export DATABRICKS_ACCOUNT_ID="<account-id>"
export DATABRICKS_CLIENT_ID="<sp-client-id>"
export DATABRICKS_CLIENT_SECRET="<sp-client-secret>"

export AWS_ACCESS_KEY_ID="<aws-access-key>"
export AWS_SECRET_ACCESS_KEY="<aws-secret-key>"
export AWS_DEFAULT_REGION="us-east-1"
```

## Run

From repo root:

```bash
cd test/terratest/complete_workspace_serverless
./test.sh
```

Reports are written to `test-reports/`.

## Test Descriptions

| Test | Description |
|------|-------------|
| `TestCompleteWorkspaceServerless_InitValidate` | Runs `terraform init` + `terraform validate` |
| `TestCompleteWorkspaceServerless_Plan` | Runs `terraform plan` and checks for non-empty output |
| `TestCompleteWorkspaceServerless_ApplyDestroy` | Full end-to-end: init → apply → output verification → destroy |
| `TestCompleteWorkspaceServerless_VariableValidation` | Ensures tfvars file exists and parses correctly |
| `TestCompleteWorkspaceServerless_InputAssertions` | Parameter-only assertions (no cloud calls) |
| `TestCompleteWorkspaceServerless_MinimalConfig` | Validates only required vars are needed |
| `TestCompleteWorkspaceServerless_WithCrossAccountRole` | Validates cross-account IAM role configuration |

## Keep Resources

Set `KEEP_RESOURCES=true` to skip the `terraform destroy` step (useful in production SE tests):

```bash
export KEEP_RESOURCES=true
cd test/terratest/complete_workspace_serverless
./test.sh
```
