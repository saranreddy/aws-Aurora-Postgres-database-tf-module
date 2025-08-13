terraform {
  backend "s3" {
    # Replace this with the desired key name for storing the Terraform state file in the bucket.
    key            = "rds-EA/terraform.tfstate"
    bucket         = "dj-common-terraform-state-umb"
    dynamodb_table = "terraform-aws-rds-state-lock"
    # Replace this with the AWS region where your S3 bucket is located.
    region  = "us-east-2"
    encrypt = true
  }
}
