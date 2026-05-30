resource "aws_s3_bucket" "export" {
  bucket = "undercontroll-${var.env}-export-bucket"

  tags = {
    Env = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "export_access_block" {
  bucket = aws_s3_bucket.export.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "export_tiering_configuration" {
  bucket = aws_s3_bucket.export.id
  name   = "EntireBucket"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 125
  }
}

resource "aws_s3_bucket" "announcement_image_upload" {
  bucket = "undercontroll-${var.env}-announcement-image-upload"

  tags = {
    Env = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "announcement_image_upload_access_block" {
  bucket = aws_s3_bucket.announcement_image_upload.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "announcement_image_upload_cors" {
  bucket = aws_s3_bucket.announcement_image_upload.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT"]
    allowed_origins = var.frontend_allowed_origins
    expose_headers  = ["ETag"]
    max_age_seconds = 3600
  }
}
