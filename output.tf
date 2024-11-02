output "lb_dns_name" {
  value       = "http://${aws_lb.web_app.dns_name}"
  description = "The DNS name of the App1 Load Balancer."
}

