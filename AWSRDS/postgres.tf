resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.project_name}-db-test-rds-subnet-group"
  # we use the private subnets to make the database private
  #subnet_ids = [var.intra_subnets[0], var.intra_subnets[1]]
  subnet_ids = local.private_subnet_ids

  tags = {
    Name = var.project_name
  }
}

resource "aws_security_group" "aurora" {
  name   = "${var.global_prefix}-aurora-rds"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 8432
    to_port     = 8432
    protocol    = "TCP"
    cidr_blocks = [local.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "${var.postgres_identifier}-rds-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  availability_zones      = split(",", var.availability_zones)
  backup_retention_period = 14
  preferred_backup_window = "04:00-05:00"
  master_username         = data.aws_ssm_parameter.postgres_username.value
  master_password         = data.aws_ssm_parameter.postgres_password.value
  skip_final_snapshot     = true
  #apply_immediately = true
  deletion_protection  = false
  storage_encrypted    = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  #db_cluster_parameter_group_name = aws_db_parameter_group.rds_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_rds_cluster_parameter_group.name
  final_snapshot_identifier       = "${var.postgres_identifier}-aurora-rds-cluster-backup"
  vpc_security_group_ids          = [aws_security_group.aurora.id]
  allow_major_version_upgrade     = true
  port                            = 8432
  enabled_cloudwatch_logs_exports = ["postgresql"]
  lifecycle {
    ignore_changes = [engine_version]
  }
  tags = {
    Backup       = "EC2_Daily"
    map-migrated = "d-server-03kz1vtdt7af5p"
  }
}

resource "aws_rds_cluster_instance" "rds-instance" {
  identifier         = "${var.postgres_identifier}-aurora-rds-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.rds.cluster_identifier
  engine             = "aurora-postgresql"
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  #publicly_accessible = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  count                = length(split(",", var.availability_zones))
  apply_immediately    = true
  #db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_rds_cluster_parameter_group.id
  #db_parameter_group_name = aws_db_parameter_group.aurora_rds_cluster_parameter_group.id
  depends_on = [aws_rds_cluster.rds] # Ensure instances are created after the cluster
  tags = {
    Backup       = "EC2_Daily"
    map-migrated = "d-server-03kzlvtdt7af5p"
  }
}
