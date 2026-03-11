resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name              = var.frontend_bucket_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = var.s3_origin_name
  }

  enabled         = true
  is_ipv6_enabled = true
  web_acl_id      = "arn:aws:wafv2:us-east-1:304361287196:global/webacl/CreatedByCloudFront-fc8aac5b/723ef380-03e5-4cf2-9bd4-450f2485155f"

  default_cache_behavior {
    target_origin_id       = var.s3_origin_name
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Env = var.env
  }
}
