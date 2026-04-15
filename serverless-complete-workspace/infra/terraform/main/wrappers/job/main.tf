# Wrapper: job
module "job" {
  source = "../../modules/job"

  name                          = var.name
  description                   = var.description
  timeout_seconds               = var.timeout_seconds
  max_concurrent_runs           = var.max_concurrent_runs
  max_retries                   = var.max_retries
  min_retry_interval_millis     = var.min_retry_interval_millis
  retry_on_timeout              = var.retry_on_timeout
  tags                          = var.tags
  control_run_state             = var.control_run_state
  tasks                         = var.tasks
  schedule                      = var.schedule
  trigger                       = var.trigger
  continuous                    = var.continuous
  git_source                    = var.git_source
  job_clusters                  = var.job_clusters
  email_notifications           = var.email_notifications
  webhook_notifications         = var.webhook_notifications
  parameters                    = var.parameters
  run_as_service_principal_name = var.run_as_service_principal_name
  format                        = var.format
  environments                  = var.environments
}
