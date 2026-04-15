# Persona: Workspace Admin / Service Principal
# Full manage rights across all Databricks objects

databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
group_name            = "workspace-admin-sp"
group_id              = "1234567890"
workspace_id          = "1234567890123456"
workspace_permissions = ["ADMIN"]

catalog_grants = {
  "my_catalog" = [
    "ALL_PRIVILEGES"
  ]
}

schema_grants = {
  "my_catalog.bronze" = ["ALL_PRIVILEGES"]
  "my_catalog.silver" = ["ALL_PRIVILEGES"]
  "my_catalog.gold"   = ["ALL_PRIVILEGES"]
}

table_grants = {
  "my_catalog.bronze.raw_events" = ["ALL_PRIVILEGES"]
  "my_catalog.silver.cleaned"    = ["ALL_PRIVILEGES"]
  "my_catalog.gold.aggregated"   = ["ALL_PRIVILEGES"]
}
