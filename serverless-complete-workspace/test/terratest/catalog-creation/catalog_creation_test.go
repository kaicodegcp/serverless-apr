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
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main", "wrappers", "catalog-creation"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-catalog-creation.auto.tfvars")
}

// ---------------------------------------------------------------------------
// Test 1: Init + Validate
// ---------------------------------------------------------------------------

func TestCatalogCreation_InitValidate(t *testing.T) {
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
	t.Log("Init + Validate passed for catalog-creation")
}

// ---------------------------------------------------------------------------
// Test 2: Plan
// ---------------------------------------------------------------------------

func TestCatalogCreation_Plan(t *testing.T) {
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
	t.Log("Plan passed for catalog-creation")
}

// ---------------------------------------------------------------------------
// Test 3: Apply + Destroy (end-to-end)
// ---------------------------------------------------------------------------

func TestCatalogCreation_ApplyDestroy(t *testing.T) {
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

	catalog_id := terraform.Output(t, opts, "catalog_id")
	require.NotEmpty(t, catalog_id, "catalog_id should not be empty")
	catalog_name := terraform.Output(t, opts, "catalog_name")
	require.NotEmpty(t, catalog_name, "catalog_name should not be empty")
	storage_credential_id := terraform.Output(t, opts, "storage_credential_id")
	require.NotEmpty(t, storage_credential_id, "storage_credential_id should not be empty")
	external_location_name := terraform.Output(t, opts, "external_location_name")
	require.NotEmpty(t, external_location_name, "external_location_name should not be empty")
	external_location_id := terraform.Output(t, opts, "external_location_id")
	require.NotEmpty(t, external_location_id, "external_location_id should not be empty")
	s3_bucket_name := terraform.Output(t, opts, "s3_bucket_name")
	require.NotEmpty(t, s3_bucket_name, "s3_bucket_name should not be empty")
	iam_role_arn := terraform.Output(t, opts, "iam_role_arn")
	require.NotEmpty(t, iam_role_arn, "iam_role_arn should not be empty")
	kms_key_arn := terraform.Output(t, opts, "kms_key_arn")
	require.NotEmpty(t, kms_key_arn, "kms_key_arn should not be empty")
	schema_ids := terraform.Output(t, opts, "schema_ids")
	require.NotEmpty(t, schema_ids, "schema_ids should not be empty")

	t.Logf("catalog_id = %s", catalog_id)
	t.Logf("catalog_name = %s", catalog_name)
	t.Logf("storage_credential_id = %s", storage_credential_id)
	t.Logf("external_location_name = %s", external_location_name)
	t.Logf("external_location_id = %s", external_location_id)
	t.Logf("s3_bucket_name = %s", s3_bucket_name)
	t.Logf("iam_role_arn = %s", iam_role_arn)
	t.Logf("kms_key_arn = %s", kms_key_arn)
	t.Logf("schema_ids = %s", schema_ids)
}

// ---------------------------------------------------------------------------
// Test 4: Variable Validation
// ---------------------------------------------------------------------------

func TestCatalogCreation_VariableValidation(t *testing.T) {
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
	t.Log("Variable validation passed for catalog-creation")
}

// ---------------------------------------------------------------------------
// Test 5: Input Assertions (no cloud calls)
// ---------------------------------------------------------------------------

func TestCatalogCreation_InputAssertions(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	// Verify terraform directory exists and is accessible
	_, err := os.Stat(terraformDir)
	require.NoError(t, err, "terraform directory should exist")

	// Verify main.tf exists in the terraform directory
	mainTf := filepath.Join(terraformDir, "main.tf")
	_, err = os.Stat(mainTf)
	require.NoError(t, err, "main.tf should exist in terraform directory")

	// Verify variables.tf exists
	varsTf := filepath.Join(terraformDir, "variables.tf")
	_, err = os.Stat(varsTf)
	require.NoError(t, err, "variables.tf should exist in terraform directory")

	// Verify outputs.tf exists
	outputsTf := filepath.Join(terraformDir, "outputs.tf")
	_, err = os.Stat(outputsTf)
	require.NoError(t, err, "outputs.tf should exist in terraform directory")

	// Verify tfvars file exists and is readable
	_, err = os.Stat(varFile)
	require.NoError(t, err, "tfvars file should exist")

	data, err := os.ReadFile(varFile)
	require.NoError(t, err, "tfvars file should be readable")
	assert.NotEmpty(t, string(data), "tfvars file should not be empty")

	t.Log("Input assertions passed for catalog-creation")
}
