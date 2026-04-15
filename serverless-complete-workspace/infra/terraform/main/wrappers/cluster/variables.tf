variable "databricks_account_id" {
  description = "Databricks account ID."
  type        = string
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "spark_version" {
  description = "Runtime version of the cluster"
  type        = string
}

variable "node_type_id" {
  description = "The type of AWS instance for worker nodes"
  type        = string
}

variable "driver_node_type_id" {
  description = "The type of AWS instance for the driver node"
  type        = string
  default     = null
}

variable "num_workers" {
  description = "Number of worker nodes"
  type        = number
  default     = null
}

variable "autoscale" {
  description = "Autoscaling configuration"
  type = object({
    min_workers = number
    max_workers = number
  })
  default = null
}

variable "autotermination_minutes" {
  description = "Auto-terminate after inactivity (minutes)"
  type        = number
  default     = 10
}

variable "spark_conf" {
  description = "Map of Spark configuration properties"
  type        = map(string)
  default     = {}
}

variable "custom_tags" {
  description = "Custom tags for cluster resources"
  type        = map(string)
  default     = {}
}

variable "spark_env_vars" {
  description = "Environment variables for Spark"
  type        = map(string)
  default     = {}
}

variable "enable_elastic_disk" {
  description = "Enable elastic disk on the cluster"
  type        = bool
  default     = true
}

variable "enable_local_disk_encryption" {
  description = "Enable local disk encryption"
  type        = bool
  default     = true
}

variable "data_security_mode" {
  description = "Data security mode"
  type        = string
  default     = "USER_ISOLATION"
}

variable "runtime_engine" {
  description = "Runtime engine (STANDARD or PHOTON)"
  type        = string
  default     = "STANDARD"
}

variable "instance_pool_id" {
  description = "Instance pool ID for worker nodes"
  type        = string
  default     = null
}

variable "driver_instance_pool_id" {
  description = "Instance pool ID for the driver node"
  type        = string
  default     = null
}

variable "policy_id" {
  description = "Cluster policy ID"
  type        = string
  default     = null
}

variable "single_user_name" {
  description = "Single user name for single-user clusters"
  type        = string
  default     = null
}

variable "idempotency_token" {
  description = "Idempotency token for cluster creation"
  type        = string
  default     = null
}

variable "apply_policy_default_values" {
  description = "Whether to apply policy default values"
  type        = bool
  default     = true
}

variable "aws_attributes" {
  description = "AWS-specific attributes for the cluster"
  type = object({
    zone_id                = optional(string)
    availability           = optional(string, "SPOT_WITH_FALLBACK")
    spot_bid_price_percent = optional(number, 100)
    instance_profile_arn   = optional(string)
    first_on_demand        = optional(number, 1)
    ebs_volume_type        = optional(string, "GENERAL_PURPOSE_SSD")
    ebs_volume_count       = optional(number, 1)
    ebs_volume_size        = optional(number, 100)
  })
  default = null
}

variable "init_scripts" {
  description = "List of init scripts"
  type = list(object({
    s3 = optional(object({
      destination = string
      region      = optional(string)
      endpoint    = optional(string)
    }))
    volumes = optional(object({
      destination = string
    }))
    workspace = optional(object({
      destination = string
    }))
  }))
  default = []
}

variable "libraries" {
  description = "List of libraries to install"
  type = list(object({
    jar = optional(string)
    egg = optional(string)
    whl = optional(string)
    pypi = optional(object({
      package = string
      repo    = optional(string)
    }))
    maven = optional(object({
      coordinates = string
      repo        = optional(string)
      exclusions  = optional(list(string))
    }))
  }))
  default = []
}

variable "cluster_log_conf" {
  description = "Cluster log configuration"
  type = object({
    s3 = optional(object({
      destination       = string
      region            = optional(string)
      endpoint          = optional(string)
      enable_encryption = optional(bool)
      encryption_type   = optional(string)
      kms_key           = optional(string)
      canned_acl        = optional(string)
    }))
  })
  default = null
}

variable "workload_type" {
  description = "Workload type configuration"
  type = object({
    clients = optional(object({
      jobs      = optional(bool)
      notebooks = optional(bool)
    }))
  })
  default = null
}

variable "enable_enhanced_security" {
  description = "Enable enhanced security Spark configurations"
  type        = bool
  default     = true
}

variable "allowed_languages" {
  description = "Allowed languages for notebooks"
  type        = string
  default     = "python,sql,scala"
}
