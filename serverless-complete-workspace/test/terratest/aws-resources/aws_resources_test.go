package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// ---------------------------------------------------------------------------
// Helper: resolve paths relative to the test folder
// ---------------------------------------------------------------------------

func getTerraformDir(t *testing.T) string {
	cwd, err := os.Getwd()
	require.NoError(t, err)
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main", "wrappers", "aws-resources"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-aws-resources.auto.tfvars")
}

// ---------------------------------------------------------------------------
// Test 1: Init + Validate
// ---------------------------------------------------------------------------

func TestAwsResources_InitValidate(t *testing.T) {
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
	t.Log("Init + Validate passed for aws-resources")
}

// ---------------------------------------------------------------------------
// Test 2: Plan
// ---------------------------------------------------------------------------

func TestAwsResources_Plan(t *testing.T) {
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
	t.Logf("Plan output length: %d characters", len(planOutput))
	t.Log("Plan passed for aws-resources")
}

// ---------------------------------------------------------------------------
// Test 3: Apply + Destroy (end-to-end)
// ---------------------------------------------------------------------------

func TestAwsResources_ApplyDestroy(t *testing.T) {
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

	bucketId := terraform.Output(t, opts, "bucket_id")
	require.NotEmpty(t, bucketId, "bucket_id should not be empty")
	kmsKeyArn := terraform.Output(t, opts, "kms_key_arn")
	require.NotEmpty(t, kmsKeyArn, "kms_key_arn should not be empty")

	t.Logf("bucket_id = %s", bucketId)
	t.Logf("kms_key_arn = %s", kmsKeyArn)
}

// ---------------------------------------------------------------------------
// Test 4: Variable Validation
// ---------------------------------------------------------------------------

func TestAwsResources_VariableValidation(t *testing.T) {
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
	t.Log("Variable validation passed for aws-resources")
}

// ---------------------------------------------------------------------------
// Test 5: Input Assertions (no cloud calls)
// ---------------------------------------------------------------------------

func TestAwsResources_InputAssertions(t *testing.T) {
	terraformDir := getTerraformDir(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		NoColor:      true,
	}

	assert.NotNil(t, opts.TerraformDir)
	assert.NotEmpty(t, opts.TerraformDir)
	assert.NotNil(t, opts.Vars["bucket_name"], "bucket_name should be set")
	assert.NotNil(t, opts.Vars["name_prefix"], "name_prefix should be set")

	t.Log("Input assertions passed for aws-resources")
}
