# output "nginx_url" {
#   value = aws_lb.nginx_alb.dns_name
# }

# output "private_ec2_ip" {
#   value = aws_instance.nginx_private_instance.private_ip
# }
output "nginx_url" {
  description = "The DNS name of the Load Balancer"
  value       = module.moveo_nginx.alb_dns_name
}
