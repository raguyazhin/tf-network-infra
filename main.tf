provider "aws" {
  region = var.region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

terraform {
  backend "s3" {
    bucket         = "s3-atmecs-source"
    key            = "aws_infra.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tfStateLock"
  }
}
