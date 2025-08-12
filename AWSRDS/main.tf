# Terraform Block and Specifies the required provider and its version for the Terraform configuration.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider Block and Configures the AWS provider with the specified region.
provider "aws" {
  region = var.aws_region
}

# Declares the "archive" provider without any specific configuration.
provider "archive" {
}
