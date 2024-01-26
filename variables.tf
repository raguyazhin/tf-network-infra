variable "region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default = "10.1.0.0/16"
}

variable "vpc_name" {
  description = "Name for VPC"
  type        = string
  default = "prod-vpc"
}