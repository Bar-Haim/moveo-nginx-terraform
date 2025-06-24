resource "aws_iam_role" "nginx_instance_role" {
  name = "nginx-instance-role-bar"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.nginx_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "nginx_instance_profile" {
  name = "nginx-instance-profile-v2"
  role = aws_iam_role.nginx_instance_role.name
}

