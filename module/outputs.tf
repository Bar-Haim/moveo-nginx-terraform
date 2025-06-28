# output "alb_dns_name" {
#   value = aws_lb.nginx_alb.dns_name
# }

# output "nginx_private_instance_private_ip" {
#   value = aws_instance.nginx_private_instance.private_ip
# }
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.nginx_alb_bar.dns_name
}
output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}
