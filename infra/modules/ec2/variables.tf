variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "services_security_group_id" {
  description = "ID of the security group to attach to the services instance"
  type        = string
}

variable "frontend_security_group_id" {
  description = "ID of the security group to attach to the frontend instance"
  type        = string
}

variable "frontend_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "services_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "services_subnet_id" {
  type = string
}

variable "frontend_subnet_id" {
  type = string
}

variable "rabbitmq_user" {
  description = "RabbitMQ default username"
  type        = string
  sensitive   = true
}

variable "rabbitmq_password" {
  description = "RabbitMQ default password"
  type        = string
  sensitive   = true
}

variable "public_key" {
  description = "SSH public key content to register as an EC2 key pair"
  type        = string
  sensitive   = true
}
