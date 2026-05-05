variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "services_private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "backend_private_subnet_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "database_private_subnet_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "observability_subnet_cidr" {
  type    = string
  default = "10.0.4.0/24"
}
