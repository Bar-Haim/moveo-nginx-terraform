resource "aws_vpc" "bar_vpc_moveo" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.bar_vpc_moveo.id
  cidr_block              = var.public_subnet_a
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.bar_vpc_moveo.id
  cidr_block              = var.public_subnet_b
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_moveo" {
  vpc_id            = aws_vpc.bar_vpc_moveo.id
  cidr_block        = var.private_subnet_moveo
  availability_zone = "us-east-1b"

  tags = {
    Name = "bar-private-subnet-moveo"
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_internet_gateway" "bar_igw" {
  vpc_id = aws_vpc.bar_vpc_moveo.id

  tags = {
    Name = "bar-internet-gateway"
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_route_table" "bar_public_rt" {
  vpc_id = aws_vpc.bar_vpc_moveo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bar_igw.id
  }

  tags = {
    Name = "bar-public-route-table"
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_route_table_association" "bar_public_rta" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.bar_public_rt.id
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.bar_igw]
}

resource "aws_nat_gateway" "bar_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = var.nat_name
  }
}

resource "aws_route_table" "bar_private_rt" {
  vpc_id = aws_vpc.bar_vpc_moveo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.bar_nat_gw.id
  }

  tags = {
    Name = "bar-private-route-table"
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_route_table_association" "bar_private_rta" {
  subnet_id      = aws_subnet.private_subnet_moveo.id
  route_table_id = aws_route_table.bar_private_rt.id
}

resource "aws_security_group" "ssh_http_sg" {
  name        = var.sg_name
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.bar_vpc_moveo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = var.sg_name
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_instance" "public_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_a.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh_http_sg.id]

  user_data = <<-EOF
#!/bin/bash
 set -e
exec > /var/log/user-data.log 2>&1
echo "🚀 Running user-data"
cat > /home/ec2-user/studykey.pem <<EOKEY
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAwv1xR5x0XpvmIrV+ffn8K9HSAxRLClPtxWxrG2ql5Xs4yytk
CTe52Qv1jxHzvSzJjLp31itOMKfwdP7EFCwPKcW9cONOC7D7Sv0XjdgQc/aTQkXt
V1rCso+GMtgmGtXyNHQA9lYax/7En474Wi6XRmMQI/IVtPrQPoObKMAQ3cUGPQ/l
RZpksnpgiSa6TDoEfyh+WzhovUB5fWAGzk4nDg91eV2SNEfmwGFRHoKWItsPC4S4
LhOKhdIPHp4His/vvBrowggiYFzhr9ZlSpg479LNdzbhrJZ9WGsNW1ORIVZ+NwXE
NkxaXOiUq43eQRlH4BtVmGaBQecWsG9YTk2kLQIDAQABAoIBAD2qVUbmbc710sQr
TcOdaWiaRKaApnKvtER5Uy4qfiii3YUzRcG8g+PmalRCwyiSn3MIDZoHvASbN+po
H66ZeHondQ/ccvQzlmVSwT40lI937X5KCxNTOruptDEkNnjKLHz2Ks+8z19sbNZh
Kp2qmmDCN3qGtuKzZ2Q9zrYGd88KUGyxWsEyxveE+diLXlo7YUbJ131N+c8YAYWX
C2+HqFIm3LHDMHp+6DHbzjVpmJWXEoVBwOOj058By0iLC17+VnkS62JFopDweOaA
ew8LV2xi2mDByioB1YmEUelAKp4ENoshXWe58epjjLn9Y2VTVpLYAQMj0ug0SYWc
gnGxumkCgYEA8vSDNWM9CBHDBB4S5qoVtY53Pr8tQK02ImhTQpSnvPMDbPHFRX8G
SRUM/bzXWoDCijIrTMwZT0n74jLoAJtR5tukH03xTXf32Ya9+JiENP88569saRPV
zSfoyKrKcq1ydp/pNYiL8ALvNjfuj8KzQyNgn3UowXSh7P6CmaTmQJMCgYEAzXWi
wP8sq211KgE7z2n+ngNnVTXzmbvg7gyFLqocTOJQTX5VJzZc+oT3GEBlX0PuX7D0
wHfhY5atgqMN/xqnDHdPR96+zbZImbM+ZiFi3MnY7s1MM4di5UKX6lrjb40gkgkX
9LbmXTSH0aYQoMvVjhXNXT28zC2GKRp3+MLlQD8CgYBOXJMdWx7KRYBTCagrAdzy
rDrF4D+mRrfZLTD9npjjlrYaI3jvS2Mpm0KPbKNBK5qTnE7e/E2Fh2VYtfaii3ZF
Mb6j4i3cQL+OR6lqTzcFKPXp/GjJE364JxEr9/pINq1emYFMpPgNt8SUBkJJ2BCd
rQFzLQSyMP4xRH23NLqXRQKBgQCgWyXR19c3XNDLHfdeZO3SyflGajtcS2S8pozz
5NT9tMzUDrvLRQTAijKIfQohllVf3i7IYUhKf/mgMj7kUhr7Acug3lqxF4oGW/1h
nMEabXeguh61QP+Qy67hvFoyYEWBdRN7bZzSNgOjPydPOIfOw3lrQpouCYHiZsQo
JYTj5QKBgEPwB4lnm1n3pGU7upj69oTdu3KGklJMZ3zMVK/yVQY1eey2esjani5j
vlF6+ew0UL3/8wO8vUMRiS/NYVEVlu/q98+UbUytIYnQ8ZUB6oX0fHsF1MUKL1E/
aLrObE1maTFOgHUWAoru4se02yKmjNpEVSWskVGIwtWHl/zxJ/3K
-----END RSA PRIVATE KEY-----
EOKEY
chmod 400 /home/ec2-user/studykey.pem
chown ec2-user:ec2-user /home/ec2-user/studykey.pem
echo "✅ Key created"
EOF
  tags = {
    Name = "public-instance"
  }
}


resource "aws_instance" "nginx_private_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet_moveo.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.ssh_http_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.nginx_instance_profile.name

user_data = <<-EOF
  #!/bin/bash
  set -xe

  echo "[INFO] Updating OS"
  dnf update -y

  echo "[INFO] Installing Docker"
  dnf install docker -y
  systemctl enable docker
  systemctl start docker
  usermod -aG docker ec2-user

  sleep 10

  echo "[INFO] Logging in to ECR..."
  aws ecr get-login-password --region us-east-1 | \
    docker login --username AWS --password-stdin 267414915135.dkr.ecr.us-east-1.amazonaws.com

  echo "[INFO] Pulling image..."
  docker pull 267414915135.dkr.ecr.us-east-1.amazonaws.com/nginx-moveo:latest

  echo "[INFO] Running container..."
  docker run -d -p 80:80 267414915135.dkr.ecr.us-east-1.amazonaws.com/nginx-moveo:latest

  echo "[INFO] Listing images..."
  docker images

  echo "[DONE] User-data script finished."
EOF

  tags = {
    Name = var.instance_name
  }
}



resource "aws_lb" "nginx_alb_bar" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
  security_groups    = [aws_security_group.ssh_http_sg.id]

  tags = {
    Name = var.alb_name
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_lb_target_group" "nginx_tg" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.bar_vpc_moveo.id

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb_bar.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "aws_lb_target_group_attachment" "nginx_attach" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = aws_instance.nginx_private_instance.id
  port             = 80

#   lifecycle {
#     prevent_destroy = true
#   }
}
