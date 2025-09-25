# AWS Backup vault in us-west-2
resource "aws_backup_vault" "aurora_backup_vault" {
  provider = aws.us-west-2
  name     = "${var.project_name}-aurora-backup-vault"
  tags = {
    Environment = var.environment
  }
}

# AWS Backup plan with hourly schedule
resource "aws_backup_plan" "aurora_backup_plan" {
  provider = aws.us-west-2
  name     = "${var.project_name}-hourly-backup-plan"

  rule {
    rule_name         = "hourly_backup_rule"
    target_vault_name = aws_backup_vault.aurora_backup_vault.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.backup_retention_days
    }
  }

  tags = {
    Environment = var.environment
  }
}

# Resource selection for Aurora cluster
resource "aws_backup_selection" "aurora_backup_selection" {
  provider     = aws.us-west-2
  name         = "${var.project_name}-aurora-backup-selection"
  plan_id      = aws_backup_plan.aurora_backup_plan.id
  iam_role_arn = aws_iam_role.backup_role.arn

  resources = [
    aws_rds_cluster.rds.arn
  ]

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "EC2_Daily"  # Using existing tag from postgres.tf
  }
}
