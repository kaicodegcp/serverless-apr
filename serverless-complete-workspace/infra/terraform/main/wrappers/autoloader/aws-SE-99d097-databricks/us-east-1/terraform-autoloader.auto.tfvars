name_prefix          = "se-serverless"
source_s3_bucket_arn = "arn:aws:s3:::app-team-data-bucket"
source_s3_bucket_id  = "app-team-data-bucket"
source_s3_path       = "s3://app-team-data-bucket/ingest/"
databricks_role_arn  = "arn:aws:iam::123456789012:role/databricks-cross-account"
target_catalog       = "se_serverless_catalog"
target_schema        = "se-serverless-test"
target_table         = "autoloader_events"
notebook_path        = "/Workspace/Pipelines/autoloader_ingest"
source_data_format   = "JSON"
s3_filter_prefix     = "ingest/"

pipeline_cluster = {
  label = "default"
  autoscale = {
    min_workers = 1
    max_workers = 4
    mode        = "ENHANCED"
  }
}
