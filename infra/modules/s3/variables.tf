variable "env" {
  type = string
}

variable "frontend_allowed_origins" {
  type    = list(string)
  default = ["*"]
}
