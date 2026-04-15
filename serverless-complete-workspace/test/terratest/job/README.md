# Job Terratest

Tests for the `job` wrapper module that provisions Databricks jobs with tasks, schedules, and notifications.

## Tests

| Test | Description |
|------|-------------|
| `TestJob_InitValidate` | Runs `terraform init` + `terraform validate` |
| `TestJob_Plan` | Runs `terraform plan` and verifies output |
| `TestJob_ApplyDestroy` | Full lifecycle: init, apply, verify outputs, destroy |
| `TestJob_VariableValidation` | Validates tfvars file exists and config is valid |
| `TestJob_InputAssertions` | Asserts required input variables are set |
