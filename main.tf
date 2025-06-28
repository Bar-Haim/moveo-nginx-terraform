terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

module "moveo_nginx" {
  source               = "./module"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_a      = "10.0.11.0/24"
  public_subnet_b      = "10.0.12.0/24"
  private_subnet_moveo = "10.0.2.0/24"
  instance_type        = "t3.micro"
  ami_id               = "ami-0c101f26f147fa7fd"
  instance_name        = "nginx-private-instance"
  key_name             = "studykey"
  alb_name             = "nginx-alb-bar"
  nat_name             = "bar-nat-gateway"
  sg_name              = "nginx-sg-bar"
  vpc_name             = "bar-vpc-moveo-project"
  tg_name              = "nginx-tg-bar"
  ecr_image_uri        = "267414915135.dkr.ecr.us-east-1.amazonaws.com/nginx-moveo:latest"
  private_key          = file("studykey.pem")
}
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    module.moveo_nginx.public_subnet_a_id,
    module.moveo_nginx.public_subnet_b_id
  ]
}

