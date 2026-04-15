# Cluster Terratest

Tests for the `cluster` wrapper module that provisions Databricks clusters with SRA security hardening.

## Tests

| Test | Description |
|------|-------------|
| `TestCluster_InitValidate` | Runs `terraform init` + `terraform validate` |
| `TestCluster_Plan` | Runs `terraform plan` and verifies output |
| `TestCluster_ApplyDestroy` | Full lifecycle: init, apply, verify outputs, destroy |
| `TestCluster_VariableValidation` | Validates tfvars file exists and config is valid |
| `TestCluster_InputAssertions` | Asserts required input variables are set |

## Usage

```bash
export DATABRICKS_HOST="https://<workspace>.cloud.databricks.com"
export DATABRICKS_TOKEN="..."
export TF_VAR_databricks_account_id="..."
./test.sh
```
