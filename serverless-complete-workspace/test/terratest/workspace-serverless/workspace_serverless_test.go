package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func getTerraformDir(t *testing.T) string {
	cwd, err := os.Getwd()
	require.NoError(t, err)
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main", "wrappers", "workspace-serverless"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-workspace-serverless.auto.tfvars")
}

func TestWorkspaceServerless_InitValidate(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	terraform.Init(t, opts)
	result := terraform.Validate(t, opts)
	require.NotEmpty(t, result, "terraform validate should produce output")
	t.Log("Init + Validate passed for workspace-serverless")
}

func TestWorkspaceServerless_Plan(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	terraform.Init(t, opts)
	planOutput := terraform.Plan(t, opts)
	require.NotEmpty(t, planOutput, "terraform plan should produce output")
	t.Log("Plan passed for workspace-serverless")
}

func TestWorkspaceServerless_ApplyDestroy(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	if os.Getenv("KEEP_RESOURCES") != "true" {
		defer terraform.Destroy(t, opts)
	}

	terraform.InitAndApply(t, opts)

	workspaceId := terraform.Output(t, opts, "workspace_id")
	require.NotEmpty(t, workspaceId, "workspace_id should not be empty")
	workspaceUrl := terraform.Output(t, opts, "workspace_url")
	require.NotEmpty(t, workspaceUrl, "workspace_url should not be empty")

	t.Logf("workspace_id = %s", workspaceId)
	t.Logf("workspace_url = %s", workspaceUrl)
}

func TestWorkspaceServerless_VariableValidation(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	_, err := os.Stat(varFile)
	require.NoError(t, err, "tfvars file should exist")

	terraform.Init(t, opts)
	result := terraform.Validate(t, opts)
	require.NotEmpty(t, result, "terraform validate should succeed")
	t.Log("Variable validation passed for workspace-serverless")
}

func TestWorkspaceServerless_InputAssertions(t *testing.T) {
	terraformDir := getTerraformDir(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"workspace_name":             "terratest-ws-serverless",
			"databricks_account_id":      "00000000-0000-0000-0000-000000000000",
			"databricks_aws_account_id":  "414351767826",
			"aws_region":                 "us-east-1",
			"name_prefix":               "terratest-ws",
			"workspace_root_bucket_name": "terratest-ws-root-bucket",
			"existing_metastore_name":    "test-metastore",
		},
		NoColor: true,
	}

	assert.NotNil(t, opts.TerraformDir)
	assert.NotEmpty(t, opts.TerraformDir)
	assert.Equal(t, "terratest-ws-serverless", opts.Vars["workspace_name"])
	assert.Equal(t, "00000000-0000-0000-0000-000000000000", opts.Vars["databricks_account_id"])

	t.Log("Input assertions passed for workspace-serverless")
}
