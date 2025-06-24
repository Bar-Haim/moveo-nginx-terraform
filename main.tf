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
  source                = "./module"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  public_subnet_cidr_b  = "10.0.3.0/24"
  private_subnet_cidr   = "10.0.2.0/24"
  instance_type         = "t3.micro"
  ami_id                = "ami-0c101f26f147fa7fd"
  instance_name         = "nginx-private-instance"
  key_name              = "studykey"
  alb_name              = "nginx-alb"
  nat_name              = "bar-nat-gateway"
  sg_name               = "nginx-sg"
  vpc_name              = "bar-vpc-moveo-project"
  tg_name               = "nginx-tg-bar"
  user_data             = file("${path.module}/module/user_data.sh")
  ecr_image_uri         = "267414915135.dkr.ecr.us-east-1.amazonaws.com/nginx-moveo:latest"
  private_key           = file("studykey.pem")
}
