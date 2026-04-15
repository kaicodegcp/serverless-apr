# =============================================================================
# AWS Resources Module for Databricks Serverless Workspace
# =============================================================================
# Creates:
#   - S3 root storage bucket (encrypted, versioned, public-access-blocked)
#   - KMS key for workspace encryption (DBFS + Managed Services)
#   - IAM cross-account role for Databricks
#   - S3 bucket policy granting Databricks access
# =============================================================================

data "aws_caller_identity" "current" {}

# -----------------------------------------------------------------------------
# S3 Root Storage Bucket
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "root_storage" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name      = var.bucket_name
    Purpose   = "databricks-workspace-root"
    ManagedBy = "terraform"
  })
}

resource "aws_s3_bucket_public_access_block" "root_storage" {
  bucket                  = aws_s3_bucket.root_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "root_storage" {
  bucket = aws_s3_bucket.root_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "root_storage" {
  bucket = aws_s3_bucket.root_storage.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# -----------------------------------------------------------------------------
# KMS Key for Workspace Encryption
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid       = "EnableRootPermissions"
    effect    = "Allow"
    actions   = ["kms:*"]
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
}

resource "aws_kms_key" "workspace" {
  description         = "KMS key for Databricks workspace ${var.name_prefix}"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.kms_policy.json

  tags = merge(var.tags, {
    Name      = "${var.name_prefix}-workspace-kms"
    ManagedBy = "terraform"
  })
}

resource "aws_kms_alias" "workspace" {
  name          = "alias/${var.name_prefix}-workspace"
  target_key_id = aws_kms_key.workspace.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root_storage" {
  bucket = aws_s3_bucket.root_storage.id

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

data "aws_iam_policy_document" "bucket_policy" {
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
      "${aws_s3_bucket.root_storage.arn}/*",
      aws_s3_bucket.root_storage.arn
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
    sid     = "PreventDBFSFromAccessingUnityCatalogMetastore"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.root_storage.arn}/unity-catalog/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.databricks_aws_account_id}:root"]
    }
  }
}

resource "aws_s3_bucket_policy" "root_storage" {
  bucket = aws_s3_bucket.root_storage.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

# -----------------------------------------------------------------------------
# IAM Cross-Account Role for Databricks
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "cross_account_assume_role" {
  count = var.create_cross_account_role ? 1 : 0

  statement {
    sid     = "AllowDatabricksAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.databricks_aws_account_id}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.databricks_account_id]
    }
  }
}

resource "aws_iam_role" "cross_account" {
  count = var.create_cross_account_role ? 1 : 0

  name               = "${var.name_prefix}-databricks-cross-account"
  assume_role_policy = data.aws_iam_policy_document.cross_account_assume_role[0].json

  tags = merge(var.tags, {
    Name      = "${var.name_prefix}-databricks-cross-account"
    ManagedBy = "terraform"
  })
}

data "aws_iam_policy_document" "cross_account_policy" {
  count = var.create_cross_account_role ? 1 : 0

  statement {
    sid    = "AllowS3Access"
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
      "${aws_s3_bucket.root_storage.arn}/*",
      aws_s3_bucket.root_storage.arn
    ]
  }

  statement {
    sid    = "AllowKMSAccess"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant",
      "kms:ListGrants",
    ]
    resources = [aws_kms_key.workspace.arn]
  }
}

resource "aws_iam_role_policy" "cross_account" {
  count = var.create_cross_account_role ? 1 : 0

  name   = "${var.name_prefix}-databricks-cross-account-policy"
  role   = aws_iam_role.cross_account[0].id
  policy = data.aws_iam_policy_document.cross_account_policy[0].json
}
