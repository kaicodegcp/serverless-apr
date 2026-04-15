# Persona: Ops / Monitoring Group
# Read/view rights for monitoring and auditing

databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
group_name            = "ops-monitoring"
group_id              = "1234567891"
workspace_id          = "1234567890123456"
workspace_permissions = ["USER"]

catalog_grants = {
  "my_catalog" = [
    "USE_CATALOG",
    "BROWSE"
  ]
}

schema_grants = {
  "my_catalog.bronze" = ["USE_SCHEMA", "SELECT"]
  "my_catalog.silver" = ["USE_SCHEMA", "SELECT"]
  "my_catalog.gold"   = ["USE_SCHEMA", "SELECT"]
}

table_grants = {
  "my_catalog.bronze.raw_events" = ["SELECT"]
  "my_catalog.silver.cleaned"    = ["SELECT"]
  "my_catalog.gold.aggregated"   = ["SELECT"]
}
