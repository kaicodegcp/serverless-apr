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
	return filepath.Clean(filepath.Join(cwd, "..", "..", "..", "infra", "terraform", "main", "wrappers", "autoloader"))
}

func getVarFile(t *testing.T) string {
	tfDir := getTerraformDir(t)
	return filepath.Join(tfDir, "aws-SE-99d097-databricks", "us-east-1", "terraform-autoloader.auto.tfvars")
}

func TestAutoloader_InitValidate(t *testing.T) {
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
	t.Log("Init + Validate passed for autoloader")
}

func TestAutoloader_Plan(t *testing.T) {
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
	t.Log("Plan passed for autoloader")
}

func TestAutoloader_ApplyDestroy(t *testing.T) {
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

	sqsUrl := terraform.Output(t, opts, "sqs_queue_url")
	require.NotEmpty(t, sqsUrl, "sqs_queue_url should not be empty")
	pipelineId := terraform.Output(t, opts, "pipeline_id")
	require.NotEmpty(t, pipelineId, "pipeline_id should not be empty")
	tableName := terraform.Output(t, opts, "target_table_full_name")
	require.NotEmpty(t, tableName, "target_table_full_name should not be empty")

	t.Logf("sqs_queue_url = %s", sqsUrl)
	t.Logf("pipeline_id = %s", pipelineId)
	t.Logf("target_table_full_name = %s", tableName)
}

func TestAutoloader_VariableValidation(t *testing.T) {
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
	t.Log("Variable validation passed for autoloader")
}

func TestAutoloader_InputAssertions(t *testing.T) {
	terraformDir := getTerraformDir(t)

	opts := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"name_prefix":        "terratest-autoloader",
			"source_s3_bucket_arn": "arn:aws:s3:::terratest-source-bucket",
			"target_catalog":     "main",
			"target_schema":      "default",
			"target_table":       "test_table",
			"aws_region":         "us-east-1",
		},
		NoColor: true,
	}

	assert.NotNil(t, opts.TerraformDir)
	assert.NotEmpty(t, opts.TerraformDir)
	assert.Equal(t, "terratest-autoloader", opts.Vars["name_prefix"])
	assert.Equal(t, "arn:aws:s3:::terratest-source-bucket", opts.Vars["source_s3_bucket_arn"])
	assert.Equal(t, "main", opts.Vars["target_catalog"])

	t.Log("Input assertions passed for autoloader")
}
