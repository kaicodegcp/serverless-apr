# Wrapper: workspace-conf
module "workspace_conf" {
  source = "../../modules/workspace-conf"

  enable_results_downloading = var.enable_results_downloading
  enable_notebook_table_clipboard = var.enable_notebook_table_clipboard
  enable_verbose_audit_logs = var.enable_verbose_audit_logs
  enable_dbfs_file_browser = var.enable_dbfs_file_browser
  enable_export_notebook = var.enable_export_notebook
  enforce_user_isolation = var.enforce_user_isolation
  store_results_in_customer_account = var.store_results_in_customer_account
  enable_upload_data_uis = var.enable_upload_data_uis
  disable_legacy_access = var.disable_legacy_access
  disable_legacy_dbfs = var.disable_legacy_dbfs
  additional_workspace_config = var.additional_workspace_config
  enable_ip_access_lists = var.enable_ip_access_lists
  enable_web_terminal = var.enable_web_terminal
  max_token_lifetime_days = var.max_token_lifetime_days
}
