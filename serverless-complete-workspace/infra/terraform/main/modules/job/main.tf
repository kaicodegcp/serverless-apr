# =============================================================================
# Databricks Job Module for Serverless Deployment
# =============================================================================
# Creates a Databricks job with tasks, schedules, triggers, and notifications
# Supports notebook, Python, SQL, and pipeline tasks
# =============================================================================

resource "databricks_job" "this" {
  name                      = var.name
  description               = var.description
  timeout_seconds           = var.timeout_seconds
  max_concurrent_runs       = var.max_concurrent_runs
  max_retries               = var.max_retries
  min_retry_interval_millis = var.min_retry_interval_millis
  retry_on_timeout          = var.retry_on_timeout
  tags                      = var.tags
  control_run_state         = var.control_run_state

  dynamic "environment" {
    for_each = var.environments
    content {
      environment_key = environment.value.environment_key
      spec {
        client = environment.value.client
      }
    }
  }

  dynamic "task" {
    for_each = var.tasks
    content {
      task_key                  = task.value.task_key
      description               = try(task.value.description, null)
      max_retries               = try(task.value.max_retries, null)
      min_retry_interval_millis = try(task.value.min_retry_interval_millis, null)
      retry_on_timeout          = try(task.value.retry_on_timeout, null)
      timeout_seconds           = try(task.value.timeout_seconds, null)

      dynamic "notebook_task" {
        for_each = try(task.value.notebook_task, null) != null ? [task.value.notebook_task] : []
        content {
          notebook_path   = notebook_task.value.notebook_path
          base_parameters = try(notebook_task.value.base_parameters, null)
          source          = try(notebook_task.value.source, null)
        }
      }

      dynamic "spark_python_task" {
        for_each = try(task.value.spark_python_task, null) != null ? [task.value.spark_python_task] : []
        content {
          python_file = spark_python_task.value.python_file
          parameters  = spark_python_task.value.parameters
          source      = spark_python_task.value.source
        }
      }

      dynamic "spark_jar_task" {
        for_each = try(task.value.spark_jar_task, null) != null ? [task.value.spark_jar_task] : []
        content {
          main_class_name = spark_jar_task.value.main_class_name
          parameters      = spark_jar_task.value.parameters
        }
      }

      dynamic "pipeline_task" {
        for_each = try(task.value.pipeline_task, null) != null ? [task.value.pipeline_task] : []
        content {
          pipeline_id  = pipeline_task.value.pipeline_id
          full_refresh = pipeline_task.value.full_refresh
        }
      }

      dynamic "sql_task" {
        for_each = try(task.value.sql_task, null) != null ? [task.value.sql_task] : []
        content {
          warehouse_id = sql_task.value.warehouse_id

          dynamic "query" {
            for_each = sql_task.value.query != null ? [sql_task.value.query] : []
            content {
              query_id = query.value.query_id
            }
          }

          dynamic "file" {
            for_each = sql_task.value.file != null ? [sql_task.value.file] : []
            content {
              path   = file.value.path
              source = file.value.source
            }
          }
        }
      }

      dynamic "depends_on" {
        for_each = try(task.value.depends_on, null) != null ? task.value.depends_on : []
        content {
          task_key = depends_on.value.task_key
        }
      }

      environment_key     = try(task.value.environment_key, null)
      existing_cluster_id = try(task.value.existing_cluster_id, null)

      dynamic "new_cluster" {
        for_each = try(task.value.new_cluster, null) != null ? [task.value.new_cluster] : []
        content {
          spark_version                = new_cluster.value.spark_version
          node_type_id                 = new_cluster.value.node_type_id
          driver_node_type_id          = try(new_cluster.value.driver_node_type_id, null)
          num_workers                  = new_cluster.value.num_workers
          spark_conf                   = try(new_cluster.value.spark_conf, null)
          custom_tags                  = try(new_cluster.value.custom_tags, null)
          spark_env_vars               = try(new_cluster.value.spark_env_vars, null)
          enable_elastic_disk          = try(new_cluster.value.enable_elastic_disk, null)
          enable_local_disk_encryption = try(new_cluster.value.enable_local_disk_encryption, null)
          data_security_mode           = try(new_cluster.value.data_security_mode, null)
          runtime_engine               = try(new_cluster.value.runtime_engine, null)
          instance_pool_id             = try(new_cluster.value.instance_pool_id, null)
          policy_id                    = try(new_cluster.value.policy_id, null)

          dynamic "aws_attributes" {
            for_each = try(new_cluster.value.aws_attributes, null) != null ? [new_cluster.value.aws_attributes] : []
            content {
              zone_id                = try(aws_attributes.value.zone_id, null)
              availability           = try(aws_attributes.value.availability, null)
              spot_bid_price_percent = try(aws_attributes.value.spot_bid_price_percent, null)
              instance_profile_arn   = try(aws_attributes.value.instance_profile_arn, null)
              first_on_demand        = try(aws_attributes.value.first_on_demand, null)
              ebs_volume_type        = try(aws_attributes.value.ebs_volume_type, null)
              ebs_volume_count       = try(aws_attributes.value.ebs_volume_count, null)
              ebs_volume_size        = try(aws_attributes.value.ebs_volume_size, null)
            }
          }
        }
      }

      dynamic "library" {
        for_each = try(task.value.libraries, null) != null ? task.value.libraries : []
        content {
          jar = library.value.jar
          egg = library.value.egg
          whl = library.value.whl

          dynamic "pypi" {
            for_each = library.value.pypi != null ? [library.value.pypi] : []
            content {
              package = pypi.value.package
              repo    = pypi.value.repo
            }
          }

          dynamic "maven" {
            for_each = library.value.maven != null ? [library.value.maven] : []
            content {
              coordinates = maven.value.coordinates
              repo        = maven.value.repo
              exclusions  = maven.value.exclusions
            }
          }
        }
      }
    }
  }

  dynamic "schedule" {
    for_each = var.schedule != null ? [var.schedule] : []
    content {
      quartz_cron_expression = schedule.value.quartz_cron_expression
      timezone_id            = schedule.value.timezone_id
      pause_status           = schedule.value.pause_status
    }
  }

  dynamic "trigger" {
    for_each = var.trigger != null ? [var.trigger] : []
    content {
      pause_status = trigger.value.pause_status

      dynamic "file_arrival" {
        for_each = trigger.value.file_arrival != null ? [trigger.value.file_arrival] : []
        content {
          url                               = file_arrival.value.url
          min_time_between_triggers_seconds = file_arrival.value.min_time_between_triggers_seconds
          wait_after_last_change_seconds    = file_arrival.value.wait_after_last_change_seconds
        }
      }
    }
  }

  dynamic "continuous" {
    for_each = var.continuous != null ? [var.continuous] : []
    content {
      pause_status = continuous.value.pause_status
    }
  }

  dynamic "git_source" {
    for_each = var.git_source != null ? [var.git_source] : []
    content {
      url      = git_source.value.url
      provider = git_source.value.provider
      branch   = git_source.value.branch
      tag      = git_source.value.tag
      commit   = git_source.value.commit
    }
  }

  dynamic "job_cluster" {
    for_each = var.job_clusters
    content {
      job_cluster_key = job_cluster.value.job_cluster_key

      dynamic "new_cluster" {
        for_each = [job_cluster.value.new_cluster]
        content {
          spark_version       = new_cluster.value.spark_version
          node_type_id        = new_cluster.value.node_type_id
          driver_node_type_id = try(new_cluster.value.driver_node_type_id, null)
          num_workers         = new_cluster.value.num_workers
          spark_conf          = try(new_cluster.value.spark_conf, null)
          custom_tags         = try(new_cluster.value.custom_tags, null)
          data_security_mode  = try(new_cluster.value.data_security_mode, null)
          runtime_engine      = try(new_cluster.value.runtime_engine, null)
          policy_id           = try(new_cluster.value.policy_id, null)

          dynamic "aws_attributes" {
            for_each = try(new_cluster.value.aws_attributes, null) != null ? [new_cluster.value.aws_attributes] : []
            content {
              zone_id                = try(aws_attributes.value.zone_id, null)
              availability           = try(aws_attributes.value.availability, null)
              spot_bid_price_percent = try(aws_attributes.value.spot_bid_price_percent, null)
              first_on_demand        = try(aws_attributes.value.first_on_demand, null)
            }
          }
        }
      }
    }
  }

  dynamic "email_notifications" {
    for_each = var.email_notifications != null ? [var.email_notifications] : []
    content {
      on_start                               = email_notifications.value.on_start
      on_success                             = email_notifications.value.on_success
      on_failure                             = email_notifications.value.on_failure
      on_duration_warning_threshold_exceeded = email_notifications.value.on_duration_warning_threshold_exceeded
      no_alert_for_skipped_runs              = email_notifications.value.no_alert_for_skipped_runs
    }
  }

  dynamic "webhook_notifications" {
    for_each = var.webhook_notifications != null ? [var.webhook_notifications] : []
    content {
      dynamic "on_start" {
        for_each = webhook_notifications.value.on_start != null ? webhook_notifications.value.on_start : []
        content {
          id = on_start.value.id
        }
      }
      dynamic "on_success" {
        for_each = webhook_notifications.value.on_success != null ? webhook_notifications.value.on_success : []
        content {
          id = on_success.value.id
        }
      }
      dynamic "on_failure" {
        for_each = webhook_notifications.value.on_failure != null ? webhook_notifications.value.on_failure : []
        content {
          id = on_failure.value.id
        }
      }
    }
  }

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name    = parameter.value.name
      default = parameter.value.default
    }
  }

  dynamic "run_as" {
    for_each = var.run_as_service_principal_name != null ? [1] : []
    content {
      service_principal_name = var.run_as_service_principal_name
    }
  }

  format = var.format
}
