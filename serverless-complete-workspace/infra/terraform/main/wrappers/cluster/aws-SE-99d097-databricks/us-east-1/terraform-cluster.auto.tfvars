cluster_name            = "se-serverless-cluster"
spark_version           = "15.4.x-scala2.12"
node_type_id            = "i3.xlarge"
autotermination_minutes = 10
data_security_mode      = "USER_ISOLATION"

autoscale = {
  min_workers = 1
  max_workers = 4
}
