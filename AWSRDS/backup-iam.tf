# IAM role for AWS Backup
resource "aws_iam_role" "backup_role" {
  provider = aws.us-west-2
  name     = "${var.project_name}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

# Attach AWS Backup service role policy
resource "aws_iam_role_policy_attachment" "backup_policy" {
  provider   = aws.us-west-2
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

# Additional policy for cross-region backup
resource "aws_iam_role_policy_attachment" "restore_policy" {
  provider   = aws.us-west-2
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.backup_role.name
}
