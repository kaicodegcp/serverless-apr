# Persona: Workspace Admin User
# Full manage rights

databricks_account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
user_name             = "admin@company.com"
user_id               = "9876543210"
workspace_id          = "1234567890123456"
workspace_permissions = ["ADMIN"]

catalog_grants = {
  "my_catalog" = ["ALL_PRIVILEGES"]
}

schema_grants = {
  "my_catalog.bronze" = ["ALL_PRIVILEGES"]
  "my_catalog.silver" = ["ALL_PRIVILEGES"]
  "my_catalog.gold"   = ["ALL_PRIVILEGES"]
}

table_grants = {
  "my_catalog.gold.aggregated" = ["ALL_PRIVILEGES"]
}
