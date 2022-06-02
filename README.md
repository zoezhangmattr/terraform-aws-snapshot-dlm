# terraform-aws-snapshot-dlm

## overview
a simple module to dlm lifycle to take ebs snapshot from instances or volumes

## Usage
see examples in example folder
```tf
module "daily" {
  source   = "../../"
  dlm_name = "daily-snapshot"
  schedules = {
    "daily" = {
      name            = "daily"
      create_interval = 24
      create_time     = "21:00" #utc time
      copy_tags       = true
      retain_count    = 1
      extra_tags_to_add = {
        "test" = "true"
      }
    }
  }
  target_tags = {
    "enable_snapshot" = "true"
  }
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_iam | if create dlm iam role or not | `bool` | true | yes |
| role_name | if create_iam is true, role name is required | `string` | "dlm-lifecycle-role" | yes |
| role_arn | if create_iam is false, role arn is required | `string` | false | yes |
| dlm_name | a name for dlm policy | `string` | false | yes |
| dlm_desc | a description for dlm policy | `string` | "ebs snapshot lifecycle policy" | no |
| state | Whether the lifecycle policy should be ENABLED or DISABLED | `string` | "ENABLED" | no |
| target_tags | a tags map, if matched snapshot will be created | `map` | {} | yes |
| schedules | a map, maxium 4 schedules can be created | `map` | {} | yes |
| resource_type| a type be targeted by the lifecycle policy. either INSTANCE or VOLUME | `string` | "INSTANCE" | no |
| policy_tags| extra tags to add to policy resource | `map` | {} | no |
