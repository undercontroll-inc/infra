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

variable "frontend_public_subnet_id" {
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
