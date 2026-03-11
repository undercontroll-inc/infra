variable "env" {
  type = string
}

variable "frontend_bucket_name" {
  type = string
}

variable "s3_origin_name" {
  type    = string
  default = "s3Origin"
}
