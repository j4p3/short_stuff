locals {
  s3_origin_id = "shortstuff_cdn_access"
}

resource "aws_cloudfront_distribution" "shortstuff_assets" {
  origin {
    domain_name = aws_s3_bucket.shortstuff_assets.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.shortstuff_assets_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "shortstuff asset cdn"

  aliases = ["assets.isthesqueezesquoze.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

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