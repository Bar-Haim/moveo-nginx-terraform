variable "vpc_cidr" {
  type = string
}

variable "private_subnet_moveo" {
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

variable "alb_name" {
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

# variable "user_data" {
#   type = string
# }

variable "private_key" {
  description = "The private key used to connect to EC2 for provisioner"
  type        = string
  sensitive   = true
}
variable "public_subnet_a" {
  type        = string
  description = "CIDR block for public subnet in AZ A"
}

variable "public_subnet_b" {
  type        = string
  description = "CIDR block for public subnet in AZ B"
}
