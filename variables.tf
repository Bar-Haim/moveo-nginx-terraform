variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "public_subnet_cidr_b" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_name" {
  type = string
}


variable "nat_name" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "tg_name" {
  type = string
}

variable "ecr_image_uri" {
  type = string
}

variable "user_data" {
  type = string
}

variable "private_key" {
  description = "The private key used to SSH into EC2"
  type        = string
  sensitive   = true
}
