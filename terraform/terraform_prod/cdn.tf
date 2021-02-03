module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["assets.isthesqueezesquoze.com"]

  comment             = "shortstuff asset cdn"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  origin = {
    app = {
      domain_name = "shortstuff-prod-92946469.us-west-1.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "app"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  viewer_certificate = {
    acm_certificate_arn = var.aws_acm_certificate
    ssl_support_method  = "sni-only"
  }
}