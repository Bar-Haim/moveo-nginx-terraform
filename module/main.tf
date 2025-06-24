
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "bar_vpc_moveo" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_moveo" {
  vpc_id                  = aws_vpc.bar_vpc_moveo.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "bar-public-subnet-moveo"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.bar_vpc_moveo.id
  cidr_block              = var.public_subnet_cidr_b
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "bar-public-subnet-b"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet_moveo" {
  vpc_id            = aws_vpc.bar_vpc_moveo.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "bar-private-subnet-moveo"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "bar_igw" {
  vpc_id = aws_vpc.bar_vpc_moveo.id

  tags = {
    Name = "bar-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "bar_public_rt" {
  vpc_id = aws_vpc.bar_vpc_moveo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bar_igw.id
  }

  tags = {
    Name = "bar-public-route-table"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "bar_public_rta" {
  subnet_id      = aws_subnet.public_subnet_moveo.id
  route_table_id = aws_route_table.bar_public_rt.id
}

# NAT Gateway Elastic IP
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.bar_igw]
}

# NAT Gateway
resource "aws_nat_gateway" "bar_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_moveo.id

  tags = {
    Name = var.nat_name
  }
}

# Private Route Table
resource "aws_route_table" "bar_private_rt" {
  vpc_id = aws_vpc.bar_vpc_moveo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.bar_nat_gw.id
  }

  tags = {
    Name = "bar-private-route-table"
  }
}

# Route Table Association for Private Subnet
resource "aws_route_table_association" "bar_private_rta" {
  subnet_id      = aws_subnet.private_subnet_moveo.id
  route_table_id = aws_route_table.bar_private_rt.id
}

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.bar_vpc_moveo.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Public EC2 Security Group
resource "aws_security_group" "public_ec2_sg" {
  name        = "public-ec2-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.bar_vpc_moveo.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private EC2 Security Group
resource "aws_security_group" "nginx_sg" {
  name        = var.sg_name
  description = "Security group for NGINX instance"
  vpc_id      = aws_vpc.bar_vpc_moveo.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}
