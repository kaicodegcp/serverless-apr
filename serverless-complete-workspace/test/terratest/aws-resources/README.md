# AWS Resources Terratest

Tests for the `aws-resources` wrapper module that provisions S3, KMS, and IAM resources for Databricks serverless workspaces.

## Tests

| Test | Description |
|------|-------------|
| `TestAwsResources_InitValidate` | Runs `terraform init` + `terraform validate` |
| `TestAwsResources_Plan` | Runs `terraform plan` and verifies output |
| `TestAwsResources_ApplyDestroy` | Full lifecycle: init, apply, verify outputs, destroy |
| `TestAwsResources_VariableValidation` | Validates tfvars file exists and config is valid |
| `TestAwsResources_InputAssertions` | Asserts required input variables are set |

## Usage

```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export TF_VAR_databricks_account_id="..."
./test.sh
```
