databricks_account_id = "00000000-0000-0000-0000-000000000000"

# Example: Set permissions on a cluster
# cluster_id = "0101-123456-abcde123"

# Example: Set permissions on a job
# job_id = "123456789"

# Example: Set permissions on a notebook
# notebook_path = "/Repos/data-engineering/etl-notebook"

# Example: Set permissions on a directory
# directory_path = "/Repos/data-engineering"

# Access control list with user, group, and service principal permissions
access_control_list = [
  # Group-level permissions
  {
    group_name       = "data-engineers"
    permission_level = "CAN_MANAGE"
  },
  {
    group_name       = "data-analysts"
    permission_level = "CAN_RESTART"
  },
  {
    group_name       = "data-viewers"
    permission_level = "CAN_ATTACH_TO"
  },
  # User-level permissions
  {
    user_name        = "admin@example.com"
    permission_level = "CAN_MANAGE"
  },
  {
    user_name        = "developer@example.com"
    permission_level = "CAN_RESTART"
  },
  # Service principal permissions
  {
    service_principal_name = "sp-etl-runner"
    permission_level       = "CAN_MANAGE"
  },
]
