resource "aws_ses_domain_identity" "domain_identity" {
  domain = data.aws_route53_zone.shortstuff.name
}

# Note: this may take up to 72 hours to verify
resource "aws_route53_record" "amazonses_verification" {
  zone_id = data.aws_route53_zone.shortstuff.id
  name    = "_amazonses.${aws_ses_domain_identity.domain_identity.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.domain_identity.verification_token]
}

resource "aws_ses_domain_mail_from" "domain_mail_from" {
  domain           = aws_ses_domain_identity.domain_identity.domain
  mail_from_domain = "mail.${aws_ses_domain_identity.domain_identity.domain}"
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = aws_ses_domain_identity.domain_identity.domain
}

resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.shortstuff.id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "domain_mail_from_mx" {
  zone_id = data.aws_route53_zone.shortstuff.id
  name    = aws_ses_domain_mail_from.domain_mail_from.mail_from_domain
  type    = "MX"
  ttl     = "600"

  # The region must match the region in which `aws_ses_domain_identity` is created
  records = ["10 feedback-smtp.${var.aws_region}.amazonses.com"]
}

resource "aws_route53_record" "domain_mail_from_spf" {
  zone_id = data.aws_route53_zone.shortstuff.id
  name    = aws_ses_domain_mail_from.domain_mail_from.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_ses_email_identity" "jp" {
  email = "jp@${aws_ses_domain_identity.domain_identity.domain}"
}
