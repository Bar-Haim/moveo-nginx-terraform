output "nginx_url" {
  value = module.moveo_nginx.alb_dns_name
}
output "private_ec2_ip" {
  value = module.moveo_nginx.nginx_private_instance_private_ip
}
