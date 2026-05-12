variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "igw_id" {
  type = string
}

variable "nat_gateway_id" {
  type = string
}

variable "alb_public_subnet_id" {
  type = string
}

variable "observability_public_subnet_id" {
  type = string
}

variable "services_private_subnet_id" {
  type = string
}

variable "backend_private_subnet_id" {
  type = string
}

variable "database_private_subnet_id" {
  type = string
}
