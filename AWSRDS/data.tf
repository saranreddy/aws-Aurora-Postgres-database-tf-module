#Data source to fetch VPC.
data "aws_vpc" "main" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

#Data source to fetch private subnet in AZ1.
data "aws_subnet" "private_az1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  #Filter for private subnets (adjust based on your tagging strategy)
  filter {
    name   = "tag:Name"
    values = ["*privatesubnet-az1"]
  }
}

#Data source to fetch private subnet in AZ2.
data "aws_subnet" "private_az2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  #Filter for private subnets (adjust based on your tagging strategy)
  filter {
    name   = "tag:Name"
    values = ["*privatesubnet-az2"]
  }
}

locals {
  vpc_id         = data.aws_vpc.main.id
  vpc_cidr_block = data.aws_vpc.main.cidr_block
  #Get exactly 2 private subnets for aurora
  private_subnet_ids = [
    data.aws_subnet.private_az1.id,
    data.aws_subnet.private_az2.id
  ]
  #Get availability zones of the selected subnets.
  availability_zones = [
    data.aws_subnet.private_az1.availability_zone,
    data.aws_subnet.private_az2.availability_zone
  ]
  #subnet count validation
  subnet_count = length(local.private_subnet_ids)
}

#Capture DB UserName and Password From SSM
data "aws_ssm_parameter" "postgres_username" {
  name             = var.ssm_postgres_username
  with_decryption = true
}

data "aws_ssm_parameter" "postgres_password" {
  name             = var.ssm_postgres_password
  with_decryption = true
}
