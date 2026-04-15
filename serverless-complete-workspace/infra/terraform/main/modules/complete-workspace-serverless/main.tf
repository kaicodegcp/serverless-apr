# =============================================================================
# Complete Databricks Serverless Workspace Module
# =============================================================================
# This module creates:
#   - S3 bucket for workspace root (with KMS, versioning, bucket policy)
#   - MWS storage configuration
#   - Customer-managed keys (storage + managed services)
#   - MWS serverless workspace (compute_mode = SERVERLESS)
#   - Metastore assignment to an existing Unity Catalog metastore
#   - Optional: Service principal for workspace automation
#   - Optional: Unity Catalog creation
# =============================================================================

# -----------------------------------------------------------------------------
# Data Sources
# -----------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

# -----------------------------------------------------------------------------
# S3 Root Storage Bucket
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "workspace_root" {
  bucket        = var.workspace_root_bucket_name
  force_destroy = var.force_destroy_buckets

  tags = merge(var.tags, {
    Name      = var.workspace_root_bucket_name
    Purpose   = "databricks-workspace-root"
    ManagedBy = "terraform"
  })
}

resource "aws_s3_bucket_public_access_block" "workspace_root" {
  bucket                  = aws_s3_bucket.workspace_root.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "workspace_root" {
  bucket = aws_s3_bucket.workspace_root.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "workspace_root" {
  bucket = aws_s3_bucket.workspace_root.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# -----------------------------------------------------------------------------
# KMS Key for Workspace Encryption
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "workspace_kms" {
  statement {
    sid    = "EnableRootPermissions"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "AllowDatabricksUseForDBFS"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.databricks_aws_account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/DatabricksAccountId"
      values   = [var.databricks_account_id]
    }
  }

  statement {
    sid    = "AllowDatabricksUseForDBFSGrants"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.databricks_aws_account_id}:root"]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/DatabricksAccountId"
      values   = [var.databricks_account_id]
    }
  }

  statement {
    sid    = "AllowDatabricksUseForManagedServices"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.databricks_aws_account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/DatabricksAccountId"
      values   = [var.databricks_account_id]
    }
  }

  dynamic "statement" {
    for_each = var.databricks_cross_account_role_arn == null ? [] : [var.databricks_cross_account_role_arn]
    content {
      sid    = "AllowDatabricksUseForEBS"
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:CreateGrant",
        "kms:DescribeKey"
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }

      condition {
        test     = "ForAnyValue:StringLike"
        variable = "kms:ViaService"
        values   = ["ec2.*.amazonaws.com"]
      }
    }
  }
}

resource "aws_kms_key" "workspace" {
  description         = "KMS key for Databricks workspace ${var.workspace_name}"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.workspace_kms.json

  tags = merge(var.tags, {
    Name      = "${var.name_prefix}-workspace-kms"
    ManagedBy = "terraform"
  })
}

resource "aws_kms_alias" "workspace" {
  name          = "alias/${var.name_prefix}-workspace"
  target_key_id = aws_kms_key.workspace.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "workspace_root" {
  bucket = aws_s3_bucket.workspace_root.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.workspace.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# -----------------------------------------------------------------------------
# S3 Bucket Policy (Databricks Access)
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "workspace_root_databricks_access" {
  statement {
    sid    = "GrantDatabricksAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      "${aws_s3_bucket.workspace_root.arn}/*",
      aws_s3_bucket.workspace_root.arn
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.databricks_aws_account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/DatabricksAccountId"
      values   = [var.databricks_account_id]
    }
  }

  statement {
    sid    = "PreventDBFSFromAccessingUnityCatalogMetastore"
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    resources = ["${aws_s3_bucket.workspace_root.arn}/unity-catalog/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.databricks_aws_account_id}:root"]
    }
  }
}

resource "aws_s3_bucket_policy" "workspace_root" {
  bucket = aws_s3_bucket.workspace_root.id
  policy = data.aws_iam_policy_document.workspace_root_databricks_access.json
}

# -----------------------------------------------------------------------------
# Databricks MWS Storage Configuration
# -----------------------------------------------------------------------------

resource "databricks_mws_storage_configurations" "this" {
  provider = databricks.mws

  account_id                 = var.databricks_account_id
  storage_configuration_name = "${var.name_prefix}-mws-storage"
  bucket_name                = aws_s3_bucket.workspace_root.id
}

# -----------------------------------------------------------------------------
# Databricks Customer-Managed Keys
# -----------------------------------------------------------------------------

resource "databricks_mws_customer_managed_keys" "managed_services" {
  provider = databricks.mws

  account_id = var.databricks_account_id
  use_cases  = ["MANAGED_SERVICES"]

  aws_key_info {
    key_arn = aws_kms_key.workspace.arn
  }
}

resource "databricks_mws_customer_managed_keys" "storage" {
  provider = databricks.mws

  account_id = var.databricks_account_id
  use_cases  = ["STORAGE"]

  aws_key_info {
    key_arn = aws_kms_key.workspace.arn
  }
}

# -----------------------------------------------------------------------------
# Databricks Serverless Workspace
# -----------------------------------------------------------------------------

resource "databricks_mws_workspaces" "this" {
  provider = databricks.mws

  account_id                               = var.databricks_account_id
  workspace_name                           = var.workspace_name
  aws_region                               = var.aws_region
  storage_configuration_id                 = databricks_mws_storage_configurations.this.storage_configuration_id
  storage_customer_managed_key_id          = databricks_mws_customer_managed_keys.storage.customer_managed_key_id
  managed_services_customer_managed_key_id = databricks_mws_customer_managed_keys.managed_services.customer_managed_key_id
  compute_mode                             = "SERVERLESS"

  depends_on = [
    aws_s3_bucket_server_side_encryption_configuration.workspace_root,
    aws_s3_bucket_ownership_controls.workspace_root,
    aws_s3_bucket_policy.workspace_root,
    databricks_mws_customer_managed_keys.storage,
    databricks_mws_customer_managed_keys.managed_services
  ]
}

# -----------------------------------------------------------------------------
# Unity Catalog Metastore Assignment
# -----------------------------------------------------------------------------

data "databricks_metastore" "existing" {
  provider = databricks.mws

  name = var.existing_metastore_name

  depends_on = [databricks_mws_workspaces.this]
}

resource "databricks_metastore_assignment" "this" {
  provider = databricks.mws

  workspace_id = databricks_mws_workspaces.this.workspace_id
  metastore_id = data.databricks_metastore.existing.metastore_id
}

# -----------------------------------------------------------------------------
# Service Principal (Optional)
# -----------------------------------------------------------------------------

resource "databricks_service_principal" "workspace_sp" {
  count    = var.enable_service_principal ? 1 : 0
  provider = databricks.mws

  display_name = var.service_principal_display_name

  depends_on = [databricks_mws_workspaces.this]
}

# -----------------------------------------------------------------------------
# Unity Catalog (Optional)
# -----------------------------------------------------------------------------

resource "databricks_catalog" "workspace_catalog" {
  count    = var.unity_catalog_name != "" ? 1 : 0
  provider = databricks.mws

  name          = var.unity_catalog_name
  storage_root  = var.unity_catalog_storage_root != "" ? var.unity_catalog_storage_root : null
  owner         = var.unity_catalog_owner != "" ? var.unity_catalog_owner : null
  force_destroy = var.force_destroy_buckets

  depends_on = [databricks_metastore_assignment.this]
}
