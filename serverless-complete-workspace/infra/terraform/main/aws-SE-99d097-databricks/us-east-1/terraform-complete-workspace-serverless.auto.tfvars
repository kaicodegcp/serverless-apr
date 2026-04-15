# =============================================================================
# SE Environment / us-east-1 — Complete Workspace Serverless
# =============================================================================
# Copy and customise for your SE environment.
# Databricks account credentials must be provided via env vars (see repo README).
# =============================================================================

# Mandatory — Databricks
databricks_account_id     = "0d26daa6-5e44-4c97-a497-ef015f91254a"
databricks_aws_account_id = "414351767826"

# Mandatory — Workspace
aws_region                 = "us-east-1"
name_prefix                = "se-serverless"
workspace_name             = "se-serverless-workspace"
workspace_root_bucket_name = "se-us-east-1-dbx-serverless-root-storage"

# Mandatory — Unity Catalog metastore (must exist in your account)
existing_metastore_name = "yankaiz-us-east-1"

# Optional
force_destroy_buckets = false

# Optional: cross-account role ARN for EBS KMS (leave null or omit if not using)
# databricks_cross_account_role_arn = "arn:aws:iam::123456789012:role/databricks-cross-account"

# Optional: service principal for workspace automation
# enable_service_principal        = true
# service_principal_display_name  = "se-serverless-sp"

# Optional: create a Unity Catalog in the workspace
# unity_catalog_name         = "se-serverless-catalog"
# unity_catalog_storage_root = "s3://se-uc-storage/serverless-catalog"
# unity_catalog_owner        = "admin@example.com"

# Notes:
# - DATABRICKS_CLIENT_ID and DATABRICKS_CLIENT_SECRET come from env vars.
# - AWS credentials come from env vars or instance profile.
# - Update values above to match your SE environment standards.
