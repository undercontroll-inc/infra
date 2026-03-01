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

variable "key_pair_name" {
  description = "Name of the existing AWS EC2 key pair (created in the AWS console, .pem downloaded)"
  type        = string
}

variable "deploy_public_key" {
  description = "SSH public key for the limited 'deploy' OS user on the frontend EC2. This user can only write to /usr/share/nginx/html and reload nginx — not sudo to root."
  type        = string
  sensitive   = true
}
