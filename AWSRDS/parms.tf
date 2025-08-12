resource "aws_rds_cluster_parameter_group" "RDSPG" {
  name        = "rds-${var.account_name}-${var.environment}-cluster-pg"
  family      = "aurora-postgresql14"
  description = "RDS default cluster parameter group"

  parameter {
    name  = "timezone"
    value = "UTC+5"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_rds_cluster_parameter_group" {
  name        = "rds-${var.account_name}-${var.environment}-pg"
  family      = "aurora-postgresql16"
  description = "RDS default cluster parameter group"

  parameter {
    name  = "timezone"
    value = "UTC+5"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "shared_buffers"
    value        = "1024"
  }

  parameter {
    name  = "work_mem"
    value = "2458"
  }

  parameter {
    name  = "maintenance_work_mem"
    value = "2458"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "effective_cache_size"
    value        = "2048"
  }

  lifecycle {
    create_before_destroy = true
  }
}
