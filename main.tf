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

resource "aws_subnet" "public_subnet" {
  count                  = length(var.public_subnet_cidr_blocks)
  vpc_id                 = aws_vpc.my_vpc.id
  cidr_block             = var.public_subnet_cidr_blocks[count.index]
  availability_zone      = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                  = length(var.private_subnet_cidr_blocks)
  vpc_id                 = aws_vpc.my_vpc.id
  cidr_block             = var.private_subnet_cidr_blocks[count.index]
  availability_zone      = "${var.region}a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id 

  tags = {
    Name = "my-nat-gateway"
  }
}

resource "aws_eip" "my_eip" {}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route" "private_route" {
  //count          = length(var.private_subnet_cidr_blocks)
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

terraform {
  backend "s3" {
    bucket         = "s3-atmecs-source"
    key            = "tf_aws_backend.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tfStateLock"
  }
}
