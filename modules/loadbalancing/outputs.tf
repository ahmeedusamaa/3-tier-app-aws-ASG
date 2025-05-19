output "lb_dns_name" {
  value = aws_lb.frontend_alb.dns_name
  
}

output "backend_lb_dns_name" {
  value = aws_lb.backend_alb.dns_name
  
}