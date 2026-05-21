output "export_bucket_name" {
  value = aws_s3_bucket.export.bucket
}

output "announcement_image_upload_name" {
  value = aws_s3_bucket.announcement_image_upload.bucket
}
