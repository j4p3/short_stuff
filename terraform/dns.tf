# # Zones

# resource "aws_route53_zone" "main" {
#   name = "isthesqueezesquoze.com."

#   tags = {
#     environment = "prod"
#   }
# }

# resource "aws_route53_zone" "dev" {
#   name = "dev.isthesqueezesquoze.com"

#   tags = {
#     environment = "dev"
#   }
# }

# # Existing records

# resource "aws_route53_record" "main_a" {
#   zone_id         = aws_route53_zone.main.id
#   name            = "isthesqueezesquoze.com."
#   type            = "A"
#   allow_overwrite = true
# }
# resource "aws_route53_record" "ns" {
#   zone_id         = aws_route53_zone.main.id
#   name            = "isthesqueezesquoze.com."
#   type            = "NS"
#   allow_overwrite = true
# }
# resource "aws_route53_record" "soa" {
#   zone_id         = aws_route53_zone.main.id
#   name            = "isthesqueezesquoze.com."
#   type            = "SOA"
#   allow_overwrite = true
# }
# resource "aws_route53_record" "cname_cloudfront_a" {
#   zone_id         = aws_route53_zone.main.id
#   name            = "_ddcf9ec0f380a1f597ffa5f0ce484549.isthesqueezesquoze.com."
#   type            = "CNAME"
#   allow_overwrite = true
# }
# resource "aws_route53_record" "cname_cloudfront_b" {
#   zone_id         = aws_route53_zone.main.id
#   name            = "_8a0ac2de3a061f3694ef01a689d19676.www.isthesqueezesquoze.com."
#   type            = "CNAME"
#   allow_overwrite = true
# }

# resource "aws_route53_record" "ns_dev" {
#   zone_id         = aws_route53_zone.main.zone_id
#   name            = "dev.example.com"
#   type            = "NS"
#   ttl             = "30"
#   records         = aws_route53_zone.dev.name_servers
#   allow_overwrite = true
# }

# resource "aws_route53_record" "cname_dev" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "dev.isthesqueezesquoze.com"
#   type    = "CNAME"
#   ttl     = "60"
#   records = [aws_lb.shortstuff.dns_name]
# }

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
