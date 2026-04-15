variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "name" {
  description = "Job name"
  type        = string
}

variable "description" {
  description = "Job description"
  type        = string
  default     = null
}

variable "timeout_seconds" {
  description = "Job timeout in seconds"
  type        = number
  default     = 0
}

variable "max_concurrent_runs" {
  description = "Maximum number of concurrent runs"
  type        = number
  default     = 1
}

variable "max_retries" {
  description = "Maximum number of retries"
  type        = number
  default     = 0
}

variable "min_retry_interval_millis" {
  description = "Minimum retry interval in milliseconds"
  type        = number
  default     = 0
}

variable "retry_on_timeout" {
  description = "Retry on timeout"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Job tags"
  type        = map(string)
  default     = {}
}

variable "control_run_state" {
  description = "Control run state"
  type        = bool
  default     = false
}

variable "tasks" {
  description = "List of job tasks"
  type        = list(any)
  default     = []
}

variable "schedule" {
  description = "Job schedule configuration"
  type = object({
    quartz_cron_expression = string
    timezone_id            = string
    pause_status           = optional(string)
  })
  default = null
}

variable "trigger" {
  description = "Job trigger configuration"
  type = object({
    pause_status = optional(string)
    file_arrival = optional(object({
      url                               = string
      min_time_between_triggers_seconds = optional(number)
      wait_after_last_change_seconds    = optional(number)
    }))
  })
  default = null
}

variable "continuous" {
  description = "Continuous job configuration"
  type = object({
    pause_status = optional(string)
  })
  default = null
}

variable "git_source" {
  description = "Git source configuration"
  type = object({
    url      = string
    provider = string
    branch   = optional(string)
    tag      = optional(string)
    commit   = optional(string)
  })
  default = null
}

variable "job_clusters" {
  description = "List of job clusters"
  type        = list(any)
  default     = []
}

variable "email_notifications" {
  description = "Email notification settings"
  type = object({
    on_start                               = optional(list(string))
    on_success                             = optional(list(string))
    on_failure                             = optional(list(string))
    on_duration_warning_threshold_exceeded = optional(list(string))
    no_alert_for_skipped_runs              = optional(bool)
  })
  default = null
}

variable "webhook_notifications" {
  description = "Webhook notification settings"
  type = object({
    on_start   = optional(list(object({ id = string })))
    on_success = optional(list(object({ id = string })))
    on_failure = optional(list(object({ id = string })))
  })
  default = null
}

variable "parameters" {
  description = "Job parameters"
  type = list(object({
    name    = string
    default = string
  }))
  default = []
}

variable "run_as_service_principal_name" {
  description = "Service principal name to run the job as"
  type        = string
  default     = null
}

variable "format" {
  description = "Job format (SINGLE_TASK or MULTI_TASK)"
  type        = string
  default     = "MULTI_TASK"
}

variable "environments" {
  description = "Job environments (e.g. serverless)"
  type = list(object({
    environment_key = string
    client          = optional(string, "1")
  }))
  default = []
}
