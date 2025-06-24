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

# EC2 Security Group
resource "aws_security_group" "nginx_sg" {
  name   = var.sg_name
  description = "Security group for NGINX instance"
  vpc_id = aws_vpc.bar_vpc_moveo.id

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
resource "aws_instance" "public_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_moveo.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]
  key_name                    = var.key_name

  provisioner "file" {
    source      = "studykey.pem"
    destination = "/home/ec2-user/studykey.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.private_key
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/studykey.pem"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("studykey.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "jumpbox-public-ec2"
  }
}

resource "aws_security_group" "public_ec2_sg" {
  name        = "public-ec2-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.bar_vpc_moveo.id

  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # או שתצמצמי ל־IP שלך
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name = "public-ec2-sg"
  }
}

# EC2 Instance in Private Subnet
resource "aws_instance" "nginx_private_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet_moveo.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = var.key_name
  iam_instance_profile = aws_iam_instance_profile.nginx_instance_profile.name


    user_data = var.user_data
    
  tags = {
    Name = var.instance_name
  }
}

# Application Load Balancer
resource "aws_lb" "nginx_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_subnet_moveo.id,
    aws_subnet.public_subnet_b.id
  ]

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "nginx_tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bar_vpc_moveo.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}


resource "aws_lb_target_group_attachment" "nginx_target" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = aws_instance.nginx_private_instance.id
  port             = 80
}
