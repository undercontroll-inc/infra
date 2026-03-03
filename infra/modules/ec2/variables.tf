variable "env" {
  type = string
}

variable "frontend_security_group_id" {
  type = string
}

variable "services_security_group_id" {
  type = string
}

variable "backend_security_group_id" {
  type = string
}

variable "database_security_group_id" {
  type = string
}

variable "frontend_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "services_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "backend_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "database_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "frontend_subnet_id" {
  type = string
}

variable "services_subnet_id" {
  type = string
}

variable "backend_subnet_id" {
  type = string
}

variable "database_subnet_id" {
  type = string
}

variable "rabbitmq_user" {
  type      = string
  sensitive = true
}

variable "rabbitmq_password" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "key_pair_name" {
  type = string
}

variable "deploy_public_key" {
  type      = string
  sensitive = true
}
