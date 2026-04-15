# =============================================================================
# Unity Catalog: Catalog + Schema Creation (from complete-workspace pattern)
# =============================================================================
# Creates: KMS key, storage credential, IAM role + policy, S3 bucket,
# external location, catalog, default namespace, and optional schemas with permissions.
# Requires: workspace has metastore assigned; AWS and Databricks workspace providers.
# =============================================================================

data "aws_caller_identity" "current" {}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  suffix                 = random_string.suffix.result
  uc_catalog_bucket_name = "${var.name_prefix}-catalog-${var.workspace_id}"
  uc_catalog_role_name   = "${var.name_prefix}-catalog-${var.workspace_id}"
  uc_catalog_name_safe   = replace(local.uc_catalog_bucket_name, "-", "_")
  uc_iam_arn             = "arn:${var.aws_partition}:iam::${data.aws_caller_identity.current.account_id}:role/${local.uc_catalog_role_name}"
  cmk_admin_value        = var.cmk_admin_arn != null ? var.cmk_admin_arn : "arn:${var.aws_partition}:iam::${data.aws_caller_identity.current.account_id}:root"
}

# -----------------------------------------------------------------------------
# KMS - Catalog storage
# -----------------------------------------------------------------------------
module "kms_catalog_storage" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 3.0"

  description = "KMS key for Databricks catalog storage"
  key_usage   = "ENCRYPT_DECRYPT"

  computed_aliases = {
    "catalog-storage" = {
      name = "${var.name_prefix}-catalog-storage-${local.suffix}-key"
    }
  }

  key_statements = [
    {
      sid    = "Enable IAM User Permissions"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = [local.cmk_admin_value]
        }
      ]
      actions   = ["kms:*"]
      resources = ["*"]
    },
    {
      sid    = "Allow IAM Role to use the key"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = [local.uc_iam_arn]
        }
      ]
      actions   = ["kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey*"]
      resources = ["*"]
    }
  ]

  tags = merge(var.tags, { Name = "${var.name_prefix}-catalog-storage-key-${local.suffix}" })
}

# -----------------------------------------------------------------------------
# Storage credential (create before IAM role; Databricks returns external_id)
# -----------------------------------------------------------------------------
resource "databricks_storage_credential" "catalog" {
  name = "${local.uc_catalog_bucket_name}-storage-credential"

  aws_iam_role {
    role_arn = local.uc_iam_arn
  }
  isolation_mode = "ISOLATION_MODE_ISOLATED"
}

data "databricks_aws_unity_catalog_assume_role_policy" "this" {
  aws_account_id        = data.aws_caller_identity.current.account_id
  role_name             = local.uc_catalog_role_name
  unity_catalog_iam_arn = var.unity_catalog_iam_arn
  external_id           = databricks_storage_credential.catalog.aws_iam_role[0].external_id
}

data "databricks_aws_unity_catalog_policy" "this" {
  aws_account_id = data.aws_caller_identity.current.account_id
  bucket_name    = local.uc_catalog_bucket_name
  role_name      = local.uc_catalog_role_name
  kms_name       = module.kms_catalog_storage.key_arn
}

module "iam_policy_unity_catalog" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"

  name   = "${var.name_prefix}-catalog-policy-${local.suffix}"
  policy = data.databricks_aws_unity_catalog_policy.this.json
}

module "iam_role_unity_catalog" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  create_role                     = true
  role_name                       = local.uc_catalog_role_name
  role_requires_mfa               = false
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.databricks_aws_unity_catalog_assume_role_policy.this.json
  trusted_role_arns               = []

  custom_role_policy_arns = [module.iam_policy_unity_catalog.arn]

  tags = merge(var.tags, { Name = local.uc_catalog_role_name })
}

module "s3_unity_catalog" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket        = local.uc_catalog_bucket_name
  force_destroy = var.force_destroy

  versioning = {
    enabled = false
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.kms_catalog_storage.key_arn
      }
    }
  }

  tags = merge(var.tags, { Name = local.uc_catalog_bucket_name })
}

resource "time_sleep" "catalog_iam_propagation" {
  depends_on      = [module.iam_role_unity_catalog]
  create_duration = "60s"
}

# -----------------------------------------------------------------------------
# External location and catalog
# -----------------------------------------------------------------------------
resource "databricks_external_location" "catalog" {
  name            = "${local.uc_catalog_bucket_name}-external-location"
  url             = "s3://${local.uc_catalog_bucket_name}/"
  credential_name = databricks_storage_credential.catalog.id
  comment         = "External location for catalog"
  isolation_mode  = "ISOLATION_MODE_ISOLATED"

  depends_on = [time_sleep.catalog_iam_propagation]
}

resource "databricks_catalog" "default" {
  name           = local.uc_catalog_name_safe
  comment        = "Catalog for workspace ${var.workspace_id}"
  isolation_mode = var.catalog_isolation_mode
  storage_root   = "s3://${local.uc_catalog_bucket_name}/"
  owner          = var.catalog_owner
  force_destroy  = var.force_destroy

  properties = merge(
    var.catalog_properties,
    { created_by = "terraform-catalog-creation-module" }
  )

  depends_on = [databricks_external_location.catalog]
}

resource "databricks_default_namespace_setting" "this" {
  namespace {
    value = local.uc_catalog_name_safe
  }
  depends_on = [databricks_catalog.default]
}

# =============================================================================
# Catalog permissions (databricks_grant)
# =============================================================================
locals {
  catalog_grant_list = concat(
    [for group_name, privs in var.permissions.groups : {
      catalog_name = databricks_catalog.default.name
      principal    = group_name
      privileges   = privs
    }],
    [for sp_key, privs in var.permissions.service_principals : {
      catalog_name = databricks_catalog.default.name
      principal    = var.databricks_service_principal_app_ids[sp_key]
      privileges   = privs
    }]
  )
  catalog_grants = { for i, g in local.catalog_grant_list : "${g.catalog_name}_${g.principal}" => g }
}

resource "databricks_grant" "catalog_permission" {
  for_each = local.catalog_grants

  catalog    = each.value.catalog_name
  principal  = each.value.principal
  privileges = each.value.privileges
}

# =============================================================================
# Schemas (from var.schemas map)
# =============================================================================
module "schema" {
  for_each = var.schemas
  source   = "./modules/schema"

  catalog_name  = databricks_catalog.default.name
  name          = each.key
  comment       = each.value.comment
  properties    = {}
  force_destroy = var.force_destroy

  depends_on = [databricks_catalog.default]
}

# Flatten schema permissions into one grant per (schema, principal, privileges) for databricks_grant
locals {
  schema_grant_list = concat(
    flatten([
      for schema_name, schema_config in var.schemas : [
        for group_name, privs in try(schema_config.permissions.groups, {}) : {
          schema_full_name = "${databricks_catalog.default.name}.${schema_name}"
          principal        = group_name
          privileges       = privs
        }
      ]
    ]),
    flatten([
      for schema_name, schema_config in var.schemas : [
        for sp_key, privs in try(schema_config.permissions.service_principals, {}) : {
          schema_full_name = "${databricks_catalog.default.name}.${schema_name}"
          principal        = var.databricks_service_principal_app_ids[sp_key]
          privileges       = privs
        }
      ]
    ])
  )
  schema_grants = { for i, g in local.schema_grant_list : "${g.schema_full_name}_${g.principal}" => g }
}

resource "databricks_grant" "schema_permission" {
  for_each = local.schema_grants

  schema     = each.value.schema_full_name
  principal  = each.value.principal
  privileges = each.value.privileges

  depends_on = [module.schema]
}
