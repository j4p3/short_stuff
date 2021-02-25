resource "aws_cloudfront_origin_access_identity" "shortstuff_assets_access_identity" {
  comment = "static asset access"
}

data "aws_iam_policy_document" "shortstuff_assets_s3_policy_document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.shortstuff_assets.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.shortstuff_assets_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket" "shortstuff_assets" {
  bucket = "assets.isthesqueezesquoze.com"

  tags = {
    app         = var.name
    environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "shortstuff_assets_s3_policy" {
  bucket = aws_s3_bucket.shortstuff_assets.id
  policy = data.aws_iam_policy_document.shortstuff_assets_s3_policy_document.json
}
