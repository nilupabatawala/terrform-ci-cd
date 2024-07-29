
# define the providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  # required_version = ">= 1.2.0"
}

# define the region
provider "aws" {
  region = "eu-north-1"
}



#configure vpc
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Terrform VPC"
  }
}

#configure public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

#configure publicprivate subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs_private, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}


#configure internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet gateway attached to the vpc"
  }
}

resource "aws_eip" "nat1" {
  vpc = true

  tags = {
    Name = "nat"
  }
}


resource "aws_eip" "nat2" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.private_subnets[0].id

  tags = {
    Name = "nat1"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.private_subnets[1].id

  tags = {
    Name = "nat2"
  }

  depends_on = [aws_internet_gateway.gw]
}

#configure public route table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route"
  }
}


resource "aws_route_table" "private_route1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }

  tags = {
    Name = "Private subnet route1 to NAT GW1"
  }
}

resource "aws_route_table" "private_route2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat2.id
  }

  tags = {
    Name = "Private subnet route2 to NAT GW2"
  }
}


#configure public route table assocations
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route.id
}

#configure private route table1 assocations
resource "aws_route_table_association" "private_subnet_asso1" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private_route1.id
}

#configure private route table2 assocations
resource "aws_route_table_association" "private_subnet_asso2" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.private_route2.id
}