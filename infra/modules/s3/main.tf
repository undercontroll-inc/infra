resource "aws_s3_bucket" "export" {
  bucket   = "${var.env}-main-bucket"
  tags = {
    Env = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "main_access_block" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "main_tiering_configuration" {
  bucket = aws_s3_bucket.main.id
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
