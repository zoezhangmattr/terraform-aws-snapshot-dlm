data "aws_iam_policy_document" "assume-role-policy" {
  count = var.create_iam ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "this" {
  count              = var.create_iam ? 1 : 0
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy[count.index].json
}

locals {
  role_arn = var.create_iam ? aws_iam_role.this[0].arn : var.role_arn
}

data "aws_iam_policy_document" "role-policy" {
  count = var.create_iam ? 1 : 0
  statement {
    sid = "ec2snapshotvolume"
    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
      "ec2:DeleteSnapshot",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "createtags"
    actions = [
      "ec2:CreateTags"
    ]
    resources = [
      "arn:aws:ec2:*::snapshot/*"
    ]
  }
}
resource "aws_iam_role_policy" "this" {
  count = var.create_iam ? 1 : 0
  name  = format("%s-%s", var.role_name, "dlm-lifecycle-policy")
  role  = aws_iam_role.this[count.index].id

  policy = data.aws_iam_policy_document.role-policy[count.index].json
}

resource "aws_dlm_lifecycle_policy" "this" {
  description        = var.dlm_desc
  execution_role_arn = local.role_arn
  state              = var.state

  policy_details {
    resource_types = [var.resource_type]

    dynamic "schedule" {
      for_each = var.schedules

      content {
        name = schedule.value["name"]

        create_rule {
          interval      = schedule.value["create_interval"]
          interval_unit = "HOURS"
          times         = [schedule.value["create_time"]]
        }

        retain_rule {
          count = schedule.value["retain_count"]
        }

        tags_to_add = merge({
          provisioner = "DLM"
        }, schedule.value["extra_tags_to_add"])

        copy_tags = schedule.value["copy_tags"]
        
      }
      
    }
    target_tags = var.target_tags
  }
  tags = merge({
    Name = var.dlm_name
  }, var.policy_tags)
}
