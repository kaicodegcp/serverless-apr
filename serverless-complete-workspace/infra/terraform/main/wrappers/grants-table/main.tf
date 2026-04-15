# Wrapper: grants-table
# Creates Unity Catalog grants for tables
# Supports granting privileges to groups, users, and service principals

module "grants" {
  source = "../../modules/grants"

  grant_list = var.grant_list
}
