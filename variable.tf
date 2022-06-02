variable "create_iam" {
  type        = bool
  description = "if true will create dlm iam role"
  default     = true
}

variable "role_arn" {
  type        = string
  description = "the iam role arn used for dlm"
  default     = ""
}
variable "role_name" {
  type        = string
  description = "if create_iam, use the role_name"
  default     = "dlm-lifecycle-role"
}

variable "target_tags" {
  description = "if tags matched, will do the snapshot"
  default     = {}
}
variable "dlm_name" {
  description = "the policy name"
  type        = string
}

variable "dlm_desc" {
  description = "the policy description"
  type        = string
  default     = "ebs snapshot lifecycle policy"
}
variable "state" {
  description = "Whether the lifecycle policy should be ENABLED or DISABLED"
  type        = string
  default     = "ENABLED"
}

variable "schedules" {
  description = "schedule rules"
  default     = {}
}

variable "policy_tags" {
  description = "extra tags config for dlm policy"
  default     = {}
}

variable "resource_type" {
  description = "a type be targeted by the lifecycle policy. either INSTANCE or VOLUME"
  default     = "INSTANCE"
  type        = string
}
