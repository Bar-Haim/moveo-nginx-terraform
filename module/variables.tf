variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "nat_name" {
  description = "Name of the NAT Gateway"
  type        = string
}

variable "sg_name" {
  description = "Name for the EC2 security group"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "tg_name" {
  description = "Name of the Target Group"
  type        = string
}

variable "ecr_image_uri" {
  description = "The URI of the ECR image to pull for NGINX"
  type        = string
}

variable "user_data" {
  description = "The user data script to initialize the instance"
  type        = string
}
variable "public_subnet_cidr_b" {
  type = string
}
