# Persona: Analyst Group
# Read/run rights for analytics and querying

databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
group_name            = "analysts"
group_id              = "1234567893"
workspace_id          = "1234567890123456"
workspace_permissions = ["USER"]

catalog_grants = {
  "my_catalog" = [
    "USE_CATALOG",
    "BROWSE"
  ]
}

schema_grants = {
  "my_catalog.silver" = ["USE_SCHEMA", "SELECT"]
  "my_catalog.gold"   = ["USE_SCHEMA", "SELECT"]
}

table_grants = {
  "my_catalog.silver.cleaned"  = ["SELECT"]
  "my_catalog.gold.aggregated" = ["SELECT"]
}
