catalog_name = "se_serverless_catalog"
schema_name  = "se-serverless-test"
name         = "se_test_table"
table_type   = "MANAGED"

columns = [
  {
    name = "id"
    type = "BIGINT"
    comment = "Primary key"
    nullable = false
  },
  {
    name = "name"
    type = "STRING"
    comment = "Record name"
  },
  {
    name = "created_at"
    type = "TIMESTAMP"
    comment = "Creation timestamp"
  },
  {
    name = "data"
    type = "STRING"
    comment = "Data payload"
  }
]
