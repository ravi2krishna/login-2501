# VPC
resource "aws_vpc" "lms-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms"
  }
}

# Web Subnet
resource "aws_subnet" "lms-web-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-web-subnet"
  }
}

# API Subnet
resource "aws_subnet" "lms-api-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-api-subnet"
  }
}

# Database Subnet
resource "aws_subnet" "lms-db-sn" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "lms-db-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lms-igw" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "lms-pub-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-igw.id
  }

  tags = {
    Name = "lms-public-rt"
  }
}

# Public Route Table Association - Web Subnet
resource "aws_route_table_association" "lms-pub-rt-asc-web" {
  subnet_id      = aws_subnet.lms-web-sn.id
  route_table_id = aws_route_table.lms-pub-rt.id
}

# Public Route Table Association - API Subnet
resource "aws_route_table_association" "lms-pub-rt-asc-api" {
  subnet_id      = aws_subnet.lms-api-sn.id
  route_table_id = aws_route_table.lms-pub-rt.id
}

# Private Route Table
resource "aws_route_table" "lms-pvt-rt" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-private-rt"
  }
}

# Private Route Table Association - Database Subnet
resource "aws_route_table_association" "lms-pvt-rt-asc-db" {
  subnet_id      = aws_subnet.lms-db-sn.id
  route_table_id = aws_route_table.lms-pvt-rt.id
}

# NACL - Web Subnet
resource "aws_network_acl" "lms-web-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-web-nacl"
  }
}

# NACL - Web Subnet Association
resource "aws_network_acl_association" "lms-web-nacl-asc" {
  network_acl_id = aws_network_acl.lms-web-nacl.id
  subnet_id      = aws_subnet.lms-web-sn.id
}

# NACL - API Subnet
resource "aws_network_acl" "lms-api-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-api-nacl"
  }
}