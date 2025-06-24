1. create main.tf. then we'll put our providor and region and run "terraform init > terraform apply.

provider "aws" {
  region = "us-east-1"
}

2. 