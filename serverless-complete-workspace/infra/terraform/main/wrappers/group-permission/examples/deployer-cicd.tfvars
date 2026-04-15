# Persona: Deployer / CI-CD Group
# Manage/run rights for deployment automation

databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
group_name            = "deployer-cicd"
group_id              = "1234567894"
workspace_id          = "1234567890123456"
workspace_permissions = ["USER"]

catalog_grants = {
  "my_catalog" = [
    "USE_CATALOG",
    "CREATE_SCHEMA"
  ]
}

schema_grants = {
  "my_catalog.bronze" = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "MODIFY"]
  "my_catalog.silver" = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "MODIFY"]
  "my_catalog.gold"   = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "MODIFY"]
}

table_grants = {
  "my_catalog.bronze.raw_events" = ["SELECT", "MODIFY"]
  "my_catalog.silver.cleaned"    = ["SELECT", "MODIFY"]
  "my_catalog.gold.aggregated"   = ["SELECT", "MODIFY"]
}
