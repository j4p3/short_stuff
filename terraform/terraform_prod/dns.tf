# @todo: manage DNS/SSL w/ TF
# 
# Zones

# resource "aws_route53_zone" "shortstuff" {
#   name = "isthesqueezesquoze.com"
# }

# resource "aws_route53_record" "soa" {
#   zone_id = aws_route53_zone.shortstuff.zone_id
#   name    = "isthesqueezesquoze.com"
#   type    = "SOA"
#   ttl     = "900"
#   records = ["ns-324.awsdns-40.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
# }

# resource "aws_route53_record" "NS" {
#   zone_id = aws_route53_zone.shortstuff.zone_id
#   name    = "isthesqueezesquoze.com"
#   type    = "NS"
#   ttl     = "172800"
#   records = [
#     "ns-324.awsdns-40.com.",
#     "ns-1085.awsdns-07.org.",
#     "ns-937.awsdns-53.net.",
#     "ns-1793.awsdns-32.co.uk."
#   ]
# }

# resource "aws_route53_record" "A" {
#   zone_id = aws_route53_zone.shortstuff.zone_id
#   name    = "isthesqueezesquoze.com"
#   type    = "A"

#   alias {
#     name = module.cdn.this_cloudfront_distribution_domain_name
#     zone_id = module.cdn.this_cloudfront_distribution_hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "shortstuff" {
#   for_each = {
#     for dvo in aws_acm_certificate.shortstuff.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   depends_on = [
#     aws_acm_certificate.shortstuff,
#     aws_route53_zone.shortstuff
#   ]

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.shortstuff.zone_id
# }
