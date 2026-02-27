variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "backend_port" {
  type        = number
  default     = 8080
  description = "Port the backend application listens on"
}
