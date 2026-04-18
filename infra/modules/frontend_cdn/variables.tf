variable "env" {
  type = string
}

variable "lb_origin_dns" {
  type        = string
  description = "Public DNS of the EIP attached to the frontend/LB EC2"
}

variable "account_id" {
  type        = string
  description = "AWS account ID — used to make the S3 bucket name globally unique"
}
