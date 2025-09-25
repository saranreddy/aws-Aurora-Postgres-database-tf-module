output "cluster_endpoint" {
  description = "The endpoint for the RDS cluster"
  value       = aws_rds_cluster.rds.endpoint
}

output "cluster_read_endpoint" {
  description = "The read endpoint for the RDS cluster"
  value       = aws_rds_cluster.rds.reader_endpoint
}

output "vpc_info" {
  value = {
    vpc_id         = local.vpc_id
    vpc_cidr_block = local.vpc_cidr_block
  }
}

output "vpc_cidr_block" {
  value = local.vpc_cidr_block
}

output "vpc_id" {
  value = local.vpc_id
}

output "backup_vault_arn" {
  description = "ARN of the backup vault"
  value       = aws_backup_vault.aurora_backup_vault.arn
}

output "backup_plan_arn" {
  description = "ARN of the backup plan"
  value       = aws_backup_plan.aurora_backup_plan.arn
}

output "backup_role_arn" {
  description = "ARN of the backup IAM role"
  value       = aws_iam_role.backup_role.arn
}
