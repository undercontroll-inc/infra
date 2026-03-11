resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${var.env}-frontend-bucket"

  tags = {
    Env = var.env
  }
}

# Bloqueia acesso publico ao bucket
resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configuração do CORS necessaria para o bucket ser acessado corretamente pelo cloudfront
resource "aws_s3_bucket_cors_configuration" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }
}

# Policy necessaria para o bucket receber acesso de leitura pelo cloudfront
data "aws_iam_policy_document" "frontend_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.frontend_bucket.arn}}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

# Faz o link entre a policy e o bucket
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = data.aws_iam_policy_document.processed_bucket_policy.json
}
