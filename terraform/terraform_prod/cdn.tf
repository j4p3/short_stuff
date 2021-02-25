resource "aws_cloudfront_distribution" "shortstuff_assets" {
  origin {
    domain_name = aws_lb.shortstuff.dns_name
    origin_id = "application_lb"

    custom_origin_config {
      http_port = aws_lb_listener.shortstuff_http.port
      https_port = aws_lb_listener.shortstuff_https.port
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = [ "TLSv1" ]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "shortstuff asset cdn"

  aliases = ["assets.isthesqueezesquoze.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "application_lb"

    forwarded_values {
      query_string = false
       headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    app         = var.name
    environment = var.environment
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.shortstuff_assets.arn
    ssl_support_method  = "sni-only"
  }
}