# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

# Business Division
variable "project_name" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
}

# AWS Account Name
variable "account_name" {
  description = "aws account name"
  type        = string
}

variable "global_prefix" {
  type = string
}

variable "availability_zones" {
  default = "us-east-2a,us-east-2b"
}

variable "postgres_identifier" {
  description = "postgres_identifier to be created"
  type        = string
}

variable "ssm_postgres_username" {
  description = "SSM parameter name for the DB password"
  type        = string
  default     = "/dbpostgress/username"
}

variable "ssm_postgres_password" {
  description = "SSM parameter name for the DB password"
  type        = string
  default     = "/dbpostgress/password"
}

variable "vpc_cidr_block" {
  description = "CIDR in which AWS Resources to be created"
  type        = string
}

variable "vpc_id" {
  description = "VPC in which AWS Resources to be created"
  type        = string
}

#Variable definitions without defaults
variable "private_subnet_ids" {
  description = "VPC private subnets"
  type        = list(string)
}

variable "instance_class" {
  description = "RDS Instance class"
  type        = string
}

variable "engine_version" {
  description = "RDS engine version"
  type        = string
}
