variable "name" {
  description = "Name of the MLflow experiment (unique path in workspace)"
  type        = string
}

variable "artifact_location" {
  description = "Path to dbfs/S3 artifact location for the experiment"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the experiment"
  type        = string
  default     = null
}
