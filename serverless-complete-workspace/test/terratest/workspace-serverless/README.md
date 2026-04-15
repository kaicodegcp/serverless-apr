# Workspace Serverless Terratest

Tests for the `workspace-serverless` wrapper module that provisions a complete Databricks serverless workspace with S3, KMS, MWS config, metastore assignment, optional service principal, and optional Unity Catalog.

## Tests

| Test | Description |
|------|-------------|
| `TestWorkspaceServerless_InitValidate` | Runs `terraform init` + `terraform validate` |
| `TestWorkspaceServerless_Plan` | Runs `terraform plan` and verifies output |
| `TestWorkspaceServerless_ApplyDestroy` | Full lifecycle: init, apply, verify outputs, destroy |
| `TestWorkspaceServerless_VariableValidation` | Validates tfvars file exists and config is valid |
| `TestWorkspaceServerless_InputAssertions` | Asserts required input variables are set |
