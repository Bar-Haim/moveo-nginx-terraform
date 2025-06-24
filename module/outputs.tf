output "alb_dns_name" {
  value = aws_lb.nginx_alb.dns_name
}
output "nginx_private_instance_private_ip" {
  value = aws_instance.nginx_private_instance.private_ip
}
