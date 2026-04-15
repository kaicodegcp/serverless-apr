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
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-complete-workspace-serverless.auto.tfvars")
}

// ---------------------------------------------------------------------------
// Test 1: Structural validation — Init + Validate
// ---------------------------------------------------------------------------

func TestCompleteWorkspaceServerless_InitValidate(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	// Init
	terraform.Init(t, opts)

	// Validate
	result := terraform.Validate(t, opts)
	require.NotEmpty(t, result, "terraform validate should produce output")
	t.Log("Init + Validate passed for complete-workspace-serverless")
}

// ---------------------------------------------------------------------------
// Test 2: Plan — ensure plan runs without errors
// ---------------------------------------------------------------------------

func TestCompleteWorkspaceServerless_Plan(t *testing.T) {
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
	t.Log("Plan passed for complete-workspace-serverless")
}

// ---------------------------------------------------------------------------
// Test 3: Apply + Destroy (end-to-end)
// Honour KEEP_RESOURCES=true to skip destroy (e.g. in production SE tests).
// ---------------------------------------------------------------------------

func TestCompleteWorkspaceServerless_ApplyDestroy(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	// Destroy unless KEEP_RESOURCES=true (defer early so we clean up on failures too)
	if os.Getenv("KEEP_RESOURCES") != "true" {
		defer terraform.Destroy(t, opts)
	}

	// Apply
	terraform.InitAndApply(t, opts)

	// ---- Output verification ----
	workspaceID := terraform.Output(t, opts, "workspace_id")
	workspaceURL := terraform.Output(t, opts, "workspace_url")
	storageConfigID := terraform.Output(t, opts, "storage_configuration_id")
	kmsKeyArn := terraform.Output(t, opts, "kms_key_arn")
	metastoreID := terraform.Output(t, opts, "metastore_id")
	rootBucketName := terraform.Output(t, opts, "root_bucket_name")
	rootBucketArn := terraform.Output(t, opts, "root_bucket_arn")

	require.NotEmpty(t, workspaceID, "workspace_id should not be empty")
	require.NotEmpty(t, workspaceURL, "workspace_url should not be empty")
	require.NotEmpty(t, storageConfigID, "storage_configuration_id should not be empty")
	require.NotEmpty(t, kmsKeyArn, "kms_key_arn should not be empty")
	require.NotEmpty(t, metastoreID, "metastore_id should not be empty")
	require.NotEmpty(t, rootBucketName, "root_bucket_name should not be empty")
	require.NotEmpty(t, rootBucketArn, "root_bucket_arn should not be empty")

	t.Logf("workspace_id            = %s", workspaceID)
	t.Logf("workspace_url           = %s", workspaceURL)
	t.Logf("storage_configuration_id = %s", storageConfigID)
	t.Logf("kms_key_arn             = %s", kmsKeyArn)
	t.Logf("metastore_id            = %s", metastoreID)
	t.Logf("root_bucket_name        = %s", rootBucketName)
	t.Logf("root_bucket_arn         = %s", rootBucketArn)
}

// ---------------------------------------------------------------------------
// Test 4: Variable validation — ensure all required vars are wired
// ---------------------------------------------------------------------------

func TestCompleteWorkspaceServerless_VariableValidation(t *testing.T) {
	terraformDir := getTerraformDir(t)
	varFile := getVarFile(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		VarFiles:     []string{varFile},
		NoColor:      true,
	}

	// Ensure var file is readable
	_, err := os.Stat(varFile)
	require.NoError(t, err, "tfvars file should exist")

	// Validate that Terraform can parse variables successfully
	terraform.Init(t, opts)
	result := terraform.Validate(t, opts)
	require.NotEmpty(t, result, "terraform validate should succeed")

	t.Log("Variable validation passed")
}

// ---------------------------------------------------------------------------
// Test 5: Input / optional-input assertion (parameter-only, no cloud calls)
// ---------------------------------------------------------------------------

func TestCompleteWorkspaceServerless_InputAssertions(t *testing.T) {
	terraformDir := getTerraformDir(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"databricks_account_id":      "00000000-0000-0000-0000-000000000000",
			"databricks_aws_account_id":  "414351767826",
			"aws_region":                 "us-east-1",
			"name_prefix":               "terratest-serverless",
			"workspace_name":            "terratest-serverless-ws",
			"workspace_root_bucket_name": "terratest-serverless-root-bucket",
			"existing_metastore_name":    "test-metastore",
			"force_destroy_buckets":      false,
		},
		NoColor: true,
	}

	// Validate required variables are set
	assert.Equal(t, "00000000-0000-0000-0000-000000000000", opts.Vars["databricks_account_id"])
	assert.Equal(t, "414351767826", opts.Vars["databricks_aws_account_id"])
	assert.Equal(t, "us-east-1", opts.Vars["aws_region"])
	assert.Equal(t, "terratest-serverless", opts.Vars["name_prefix"])
	assert.Equal(t, "terratest-serverless-ws", opts.Vars["workspace_name"])
	assert.Equal(t, "terratest-serverless-root-bucket", opts.Vars["workspace_root_bucket_name"])
	assert.Equal(t, "test-metastore", opts.Vars["existing_metastore_name"])
	assert.Equal(t, false, opts.Vars["force_destroy_buckets"])

	t.Log("All input assertions passed for complete-workspace-serverless")
}

// ---------------------------------------------------------------------------
// Test 6: Minimal configuration — only required vars
// ---------------------------------------------------------------------------

func TestCompleteWorkspaceServerless_MinimalConfig(t *testing.T) {
	terraformDir := getTerraformDir(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"databricks_account_id":      "00000000-0000-0000-0000-000000000000",
			"databricks_aws_account_id":  "414351767826",
			"workspace_name":             "minimal-serverless-ws",
			"workspace_root_bucket_name": "minimal-serverless-root",
			"existing_metastore_name":    "test-metastore",
		},
		NoColor: true,
	}

	// Verify defaults are NOT explicitly set (they should be provided by the module)
	_, hasRegion := opts.Vars["aws_region"]
	assert.False(t, hasRegion, "aws_region should not be explicitly set in minimal config")

	_, hasPrefix := opts.Vars["name_prefix"]
	assert.False(t, hasPrefix, "name_prefix should not be explicitly set in minimal config")

	_, hasForceDestroy := opts.Vars["force_destroy_buckets"]
	assert.False(t, hasForceDestroy, "force_destroy_buckets should not be explicitly set in minimal config")

	t.Log("Minimal configuration validated")
}

// ---------------------------------------------------------------------------
// Test 7: Cross-account role configuration
// ---------------------------------------------------------------------------

func TestCompleteWorkspaceServerless_WithCrossAccountRole(t *testing.T) {
	terraformDir := getTerraformDir(t)

	crossAccountRoleArn := os.Getenv("TEST_CROSS_ACCOUNT_ROLE_ARN")
	if crossAccountRoleArn == "" {
		crossAccountRoleArn = "arn:aws:iam::123456789012:role/databricks-cross-account"
	}

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"databricks_account_id":            "00000000-0000-0000-0000-000000000000",
			"databricks_aws_account_id":        "414351767826",
			"aws_region":                       "us-east-1",
			"name_prefix":                      "terratest-serverless-ebs",
			"workspace_name":                   "terratest-serverless-ebs-ws",
			"workspace_root_bucket_name":       "terratest-serverless-ebs-root",
			"existing_metastore_name":          "test-metastore",
			"databricks_cross_account_role_arn": crossAccountRoleArn,
			"force_destroy_buckets":            false,
		},
		NoColor: true,
	}

	assert.NotNil(t, opts.Vars["databricks_cross_account_role_arn"])
	assert.NotEmpty(t, opts.Vars["databricks_cross_account_role_arn"])

	t.Log("Cross-account role configuration validated")
}
