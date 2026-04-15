name        = "se-serverless-test-job"
description = "Test job for serverless workspace"
format      = "MULTI_TASK"

tasks = [
  {
    task_key = "ingest_data"
    notebook_task = {
      notebook_path = "/Workspace/Jobs/ingest_data"
    }
  },
  {
    task_key = "transform_data"
    notebook_task = {
      notebook_path = "/Workspace/Jobs/transform_data"
    }
    depends_on = [
      { task_key = "ingest_data" }
    ]
  },
  {
    task_key = "validate_data"
    notebook_task = {
      notebook_path = "/Workspace/Jobs/validate_data"
    }
    depends_on = [
      { task_key = "transform_data" }
    ]
  }
]

schedule = {
  quartz_cron_expression = "0 0 8 * * ?"
  timezone_id            = "America/New_York"
  pause_status           = "PAUSED"
}
