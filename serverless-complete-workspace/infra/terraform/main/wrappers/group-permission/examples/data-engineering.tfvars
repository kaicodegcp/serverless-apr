# Persona: Data Engineering Group
# Run/write style rights for data processing

databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
group_name            = "data-engineering"
group_id              = "1234567892"
workspace_id          = "1234567890123456"
workspace_permissions = ["USER"]

catalog_grants = {
  "my_catalog" = [
    "USE_CATALOG",
    "CREATE_SCHEMA"
  ]
}

schema_grants = {
  "my_catalog.bronze" = ["USE_SCHEMA", "SELECT", "MODIFY", "CREATE_TABLE", "CREATE_FUNCTION"]
  "my_catalog.silver" = ["USE_SCHEMA", "SELECT", "MODIFY", "CREATE_TABLE", "CREATE_FUNCTION"]
  "my_catalog.gold"   = ["USE_SCHEMA", "SELECT", "MODIFY", "CREATE_TABLE"]
}

table_grants = {
  "my_catalog.bronze.raw_events" = ["SELECT", "MODIFY"]
  "my_catalog.silver.cleaned"    = ["SELECT", "MODIFY"]
  "my_catalog.gold.aggregated"   = ["SELECT", "MODIFY"]
}
