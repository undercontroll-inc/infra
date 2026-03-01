variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for Terraform state backend"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "frontend_public_subnet_cidr" {
  description = "CIDR block for the frontend public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "services_private_subnet_cidr" {
  description = "CIDR block for the services private subnet (RabbitMQ + Redis)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "backend_private_subnet_cidr" {
  description = "CIDR block for the backend private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "database_private_subnet_cidr" {
  description = "CIDR block for the database private subnet (Postgres)"
  type        = string
  default     = "10.0.4.0/24"
}

variable "backend_port" {
  description = "Port the backend application listens on"
  type        = number
  default     = 8080
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
  description = "SSH public key for the limited 'deploy' OS user on the frontend EC2 (used by CI/CD SCP). Generate a dedicated keypair: ssh-keygen -t ed25519 -C 'deploy@undercontroll-ci'"
  type        = string
  sensitive   = true
}
