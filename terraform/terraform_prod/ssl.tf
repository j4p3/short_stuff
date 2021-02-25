# Application cert (default region)
resource "aws_acm_certificate" "shortstuff_application" {
  domain_name       = "isthesqueezesquoze.com"
  validation_method = "DNS"
  subject_alternative_names = [
    "www.isthesqueezesquoze.com",
    "prod.isthesqueezesquoze.com",
    "dev.isthesqueezesquoze.com",
    "assets.isthesqueezesquoze.com",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    app         = var.name
    environment = var.environment
  }
}

# Cloudfront cert created manually
data "aws_acm_certificate" "shortstuff_assets" {
  provider    = aws.east
  domain      = "isthesqueezesquoze.com"
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
