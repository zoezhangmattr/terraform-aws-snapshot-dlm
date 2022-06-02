module "daily" {
  source   = "../../"
  dlm_name = "daily-snapshot"
  schedules = {
    "daily" = {
      name            = "daily-21"
      create_interval = 24
      create_time     = "21:00" #utc time
      copy_tags       = true
      retain_count    = 1
      extra_tags_to_add = {
        "test" = "true"
      }
    }
    "daily2" = {
      name              = "daily-9"
      create_interval   = 24
      create_time       = "09:00" #utc time
      copy_tags         = true
      retain_count      = 1
      extra_tags_to_add = {}
    }
  }
  target_tags = {
    "enable_snapshot" = "true"
  }
}
