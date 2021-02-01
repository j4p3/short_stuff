# Zones

resource "aws_route53_zone" "main" {
  name = "isthesqueezesquoze.com."

  tags = {
    environment = "prod"
  }
}

resource "aws_route53_zone" "dev" {
  name = "dev.isthesqueezesquoze.com"

  tags = {
    environment = "dev"
  }
}

# Existing records

# resource "aws_route53_record" "main" {
#   zone_id         = aws_route53_zone.main.id
#   name            = "isthesqueezesquoze.com."
#   type            = "A"
#   allow_overwrite = true
# }
resource "aws_route53_record" "ns" {
  zone_id         = aws_route53_zone.main.id
  name            = "isthesqueezesquoze.com."
  type            = "NS"
  allow_overwrite = true
  ttl             = "172800"
  records = [
    "ns-324.awsdns-40.com.",
    "ns-1085.awsdns-07.org.",
    "ns-937.awsdns-53.net.",
    "1793.awsdns-32.co.uk."
  ]
}
resource "aws_route53_record" "soa" {
  zone_id         = aws_route53_zone.main.id
  name            = "isthesqueezesquoze.com."
  type            = "SOA"
  allow_overwrite = true
  ttl             = "900"
  records         = ["ns-324.awsdns-40.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
}
resource "aws_route53_record" "cname_cloudfront_a" {
  zone_id         = aws_route53_zone.main.id
  name            = "_ddcf9ec0f380a1f597ffa5f0ce484549.isthesqueezesquoze.com."
  type            = "CNAME"
  allow_overwrite = true
  ttl             = "300"
  records         = ["_de1255e84b188dd1ae4fb165d90ce0fc.vtqfhvjlcp.acm-validations.aws."]
}
resource "aws_route53_record" "cname_cloudfront_b" {
  zone_id         = aws_route53_zone.main.id
  name            = "_8a0ac2de3a061f3694ef01a689d19676.www.isthesqueezesquoze.com."
  type            = "CNAME"
  allow_overwrite = true
  ttl             = "300"
  records         = ["_da3d8999beb0e3289cc0c504cad7ed3d.vtqfhvjlcp.acm-validations.aws."]
}

resource "aws_route53_record" "ns_dev" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "dev.example.com"
  type            = "NS"
  ttl             = "30"
  records         = aws_route53_zone.dev.name_servers
  allow_overwrite = true
}

resource "aws_route53_record" "cname_dev" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dev.isthesqueezesquoze.com"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.shortstuff.dns_name]
}

# resource "aws_route53_record" "alias_route53_record" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "isthesqueezesquoze.com"
#   type    = "A"

#   alias {
#     name                   = "${aws_lb.shortstuff.dns_name}"
#     zone_id                = "${aws_lb.shortstuff.zone_id}"
#     evaluate_target_health = true
#   }

#   tags = {
#     environment = "prod"
#   }
# }
