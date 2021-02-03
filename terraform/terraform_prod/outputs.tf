output "load_balancer_dns" {
  value = aws_lb.shortstuff.dns_name
}

output "rds_host" {
  value = aws_db_instance.main.address
}

output "cdn_host" {
  value = cdn.this_cloudfront_distribution_domain_name
}
