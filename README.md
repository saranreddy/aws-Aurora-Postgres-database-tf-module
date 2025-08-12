# AWS Aurora PostgreSQL Database Terraform Module

A production-ready Terraform module for deploying AWS Aurora PostgreSQL databases with enterprise-grade configurations. 
## 🚀 Features

- **Multi-AZ Aurora PostgreSQL** deployment across availability zones
- **Environment-specific configurations** for dev, qa, staging, and production
- **Security-first approach** with private subnets, VPC restrictions, and encrypted storage
- **Automated CI/CD** with GitHub Actions workflows
- **Parameter group management** with optimized PostgreSQL settings
- **CloudWatch integration** for monitoring and logging
- **SSM Parameter Store integration** for secure credential management

## 📋 Prerequisites

Before using this module, ensure you have:

- **AWS CLI** configured with appropriate permissions
- **Terraform** >= 1.0 installed
- **S3 bucket** for Terraform state storage
- **DynamoDB table** for state locking
- **VPC** with private subnets in at least 2 availability zones
- **SSM Parameter Store** parameters for database credentials


##  Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/saranreddy/aws-Aurora-Postgres-database-tf-module.git
cd aws-Aurora-Postgres-database-tf-module/AWSRDS
```

### 2. Set Up Backend Infrastructure

You need to create the S3 bucket and DynamoDB table for Terraform state management:

```bash
# Create S3 bucket (replace with your bucket name)
aws s3 mb s3://your-terraform-state-bucket --region us-east-2

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-2
```

### 3. Configure Environment Variables

Copy the template files and fill in your values:

```bash
# For your specific environment
cp env.tfvars.template env.tfvars

# For development
cp dev.tfvars.template dev.tfvars

# For QA
cp qa.tfvars.template qa.tfvars
```

Edit the `.tfvars` files with your actual values:

```hcl
# Example: env.tfvars
account_name = "your-account-name"
project_name = "your-project-name"
environment = "your-environment"
global_prefix = "your-global-prefix"
postgres_identifier = "your-postgres-identifier"
aws_region = "us-east-2"
instance_class = "db.t3.medium"
engine_version = "16.6"
vpc_id = "vpc-your-actual-vpc-id"
vpc_cidr_block = "10.0.0.0/16"
private_subnet_ids = ["subnet-123", "subnet-456"]
```

### 4. Update Backend Configuration

Modify `backend.tf` to point to your S3 bucket:

```terraform
terraform {
  backend "s3" {
    key            = "your-project/terraform.tfstate"
    bucket         = "your-terraform-state-bucket"
    dynamodb_table = "terraform-state-lock"
    region         = "us-east-2"
    encrypt        = true
  }
}
```

##  Usage

### Basic Deployment

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file="env.tfvars"

# Apply the configuration
terraform apply -var-file="env.tfvars"
```

### Environment-Specific Deployments

```bash
# Deploy to development
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Deploy to QA
terraform plan -var-file="qa.tfvars"
terraform apply -var-file="qa.tfvars"
```

### Using GitHub Actions

The repository includes GitHub Actions workflows for automated deployment:

1. **RDS Creation**: Go to Actions → "RDS Postgres Creation" → Run workflow
2. **RDS Destruction**: Go to Actions → "RDS Destroy" → Run workflow

## 📁 Project Structure

```
aws-Aurora-Postgres-database-tf-module/
├── .github/
│   └── workflows/
│       ├── RDS.yaml          # RDS creation workflow
│       └── destroy.yaml      # RDS destruction workflow
├── AWSRDS/
│   ├── backend.tf            # S3 backend configuration
│   ├── main.tf               # Provider configuration
│   ├── vars.tf               # Input variables
│   ├── data.tf               # Data sources and locals
│   ├── postgres.tf           # Main RDS resources
│   ├── parms.tf              # Parameter groups
│   ├── output.tf             # Output values
│   ├── .gitignore            # Git ignore rules
│   ├── env.tfvars.template   # Environment template
│   ├── dev.tfvars.template   # Development template
│   └── qa.tfvars.template    # QA template
└── README.md
```

## ⚙️ Configuration Options

### Required Variables

| Variable | Description | Type | Example |
|----------|-------------|------|---------|
| `account_name` | AWS account identifier | string | `"umb-aws-ddr-qa"` |
| `project_name` | Project name | string | `"umb-aws-ddr-qa"` |
| `environment` | Environment name | string | `"qa"` |
| `aws_region` | AWS region | string | `"us-east-2"` |
| `vpc_id` | VPC ID | string | `"vpc-12345678"` |
| `private_subnet_ids` | Private subnet IDs | list(string) | `["subnet-1", "subnet-2"]` |

### Optional Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `instance_class` | RDS instance class | string | `"db.t3.medium"` |
| `engine_version` | PostgreSQL version | string | `"16.6"` |
| `backup_retention_period` | Backup retention days | number | `14` |
| `deletion_protection` | Enable deletion protection | bool | `false` |

## 🔒 Security Features

- **Private Subnets**: Database deployed in private subnets only
- **VPC Restrictions**: Access limited to VPC CIDR block
- **Encryption**: Storage encryption enabled by default
- **SSM Integration**: Credentials stored securely in Parameter Store
- **Security Groups**: Minimal required access (port 8432)

## 📊 Monitoring & Logging

The module automatically configures:

- **CloudWatch Logs**: PostgreSQL logs exported to CloudWatch
- **Performance Insights**: Database performance monitoring
- **Backup Management**: Automated daily backups with configurable retention
- **Maintenance Windows**: Scheduled maintenance during off-peak hours

## 🧹 Cleanup

To destroy the infrastructure:

```bash
# Using Terraform
terraform destroy -var-file="env.tfvars"

# Using GitHub Actions
# Go to Actions → "RDS Destroy" → Run workflow
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues

**"VPC not found" error**
- Ensure the VPC ID exists and is in the correct region
- Verify your AWS credentials have VPC access permissions

**"Subnet not found" error**
- Check that subnet IDs are correct and exist in the specified VPC
- Ensure subnets are in different availability zones

**"SSM parameter not found" error**
- Create the required SSM parameters in Parameter Store
- Verify parameter names match those in your `.tfvars` file

**"S3 backend error"**
- Ensure the S3 bucket exists and is accessible
- Verify DynamoDB table exists for state locking

### Getting Help

- Check the [Issues](../../issues) page for known problems
- Review the [GitHub Actions](../../actions) for deployment logs
- Contact the infrastructure team for support

## 📚 Additional Resources

- [AWS Aurora PostgreSQL Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraPostgreSQL.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [UMB Infrastructure Guidelines](https://umb.edu/infrastructure)

---

**Note**: This module is specifically designed for UMB infrastructure requirements. For production use, ensure all security and compliance requirements are met for your organization.

