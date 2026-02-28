variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to launch the instance into"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group to attach to the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
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
