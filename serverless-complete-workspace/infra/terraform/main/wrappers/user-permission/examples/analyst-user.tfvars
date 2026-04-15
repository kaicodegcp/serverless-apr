# Persona: Analyst User
# Read/run rights for querying

databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
user_name             = "analyst@company.com"
user_id               = "9876543211"
workspace_id          = "1234567890123456"
workspace_permissions = ["USER"]

catalog_grants = {
  "my_catalog" = ["USE_CATALOG", "BROWSE"]
}

schema_grants = {
  "my_catalog.gold" = ["USE_SCHEMA", "SELECT"]
}

table_grants = {
  "my_catalog.gold.aggregated" = ["SELECT"]
}
