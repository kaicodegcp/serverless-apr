# =============================================================================
# Autoloader Module with SQS Event Notification for Serverless Deployment
# =============================================================================
# Creates:
#   - SQS queue for S3 event notifications
#   - SQS queue policy allowing S3 to publish events
#   - S3 bucket notification configuration
#   - Databricks DLT pipeline for autoloader ingestion
#   - Loads data from S3 into catalog.schema.table
# =============================================================================

# -----------------------------------------------------------------------------
# SQS Queue for S3 Event Notifications
# -----------------------------------------------------------------------------

resource "aws_sqs_queue" "s3_events" {
  name                       = "${var.name_prefix}-s3-event-queue"
  visibility_timeout_seconds = var.sqs_visibility_timeout
  message_retention_seconds  = var.sqs_message_retention
  receive_wait_time_seconds  = var.sqs_receive_wait_time

  tags = merge(var.tags, {
    Name      = "${var.name_prefix}-s3-event-queue"
    Purpose   = "databricks-autoloader-s3-events"
    ManagedBy = "terraform"
  })
}

resource "aws_sqs_queue" "s3_events_dlq" {
  count = var.enable_dead_letter_queue ? 1 : 0

  name                      = "${var.name_prefix}-s3-event-dlq"
  message_retention_seconds = 1209600

  tags = merge(var.tags, {
    Name      = "${var.name_prefix}-s3-event-dlq"
    Purpose   = "databricks-autoloader-dead-letter"
    ManagedBy = "terraform"
  })
}

resource "aws_sqs_queue_redrive_policy" "s3_events" {
  count = var.enable_dead_letter_queue ? 1 : 0

  queue_url = aws_sqs_queue.s3_events.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.s3_events_dlq[0].arn
    maxReceiveCount     = 3
  })
}

# -----------------------------------------------------------------------------
# SQS Queue Policy (Allow S3 to publish events)
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    sid    = "AllowS3ToPublishEvents"
    effect = "Allow"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [aws_sqs_queue.s3_events.arn]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.source_s3_bucket_arn]
    }
  }

  statement {
    sid    = "AllowDatabricksToConsumeEvents"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ChangeMessageVisibility"
    ]
    resources = [aws_sqs_queue.s3_events.arn]

    principals {
      type        = "AWS"
      identifiers = [var.databricks_role_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "s3_events" {
  queue_url = aws_sqs_queue.s3_events.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

# -----------------------------------------------------------------------------
# S3 Bucket Notification Configuration
# -----------------------------------------------------------------------------

resource "aws_s3_bucket_notification" "s3_events" {
  count  = var.configure_s3_notification ? 1 : 0
  bucket = var.source_s3_bucket_id

  queue {
    queue_arn     = aws_sqs_queue.s3_events.arn
    events        = var.s3_event_types
    filter_prefix = var.s3_filter_prefix
    filter_suffix = var.s3_filter_suffix
  }

  depends_on = [aws_sqs_queue_policy.s3_events]
}

# -----------------------------------------------------------------------------
# Databricks DLT Pipeline for Autoloader Ingestion
# -----------------------------------------------------------------------------

resource "databricks_pipeline" "autoloader" {
  name    = "${var.name_prefix}-autoloader-pipeline"
  storage = var.pipeline_storage_path
  target  = var.target_schema

  channel = var.pipeline_channel
  edition = var.pipeline_edition
  photon  = var.enable_photon

  continuous = var.continuous_mode

  catalog = var.target_catalog

  dynamic "cluster" {
    for_each = var.pipeline_cluster != null ? [var.pipeline_cluster] : []
    content {
      label       = cluster.value.label
      num_workers = cluster.value.num_workers

      dynamic "autoscale" {
        for_each = cluster.value.autoscale != null ? [cluster.value.autoscale] : []
        content {
          min_workers = autoscale.value.min_workers
          max_workers = autoscale.value.max_workers
          mode        = autoscale.value.mode
        }
      }
    }
  }

  library {
    notebook {
      path = var.notebook_path
    }
  }

  configuration = merge(
    {
      "source_path"     = var.source_s3_path
      "target_table"    = var.target_table
      "sqs_queue_url"   = aws_sqs_queue.s3_events.url
      "source_format"   = var.source_data_format
      "checkpoint_path" = var.checkpoint_path
    },
    var.extra_configuration
  )

  tags = var.tags
}
