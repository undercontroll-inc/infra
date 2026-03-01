output "rabbitmq_private_ip" {
  description = "Private IP of the RabbitMQ EC2 instance. Use this as the AMQP host in backend and notification-api (spring.rabbitmq.host)"
  value       = module.ec2.services_private_ip
}

output "frontend_private_ip" {
  description = "Private IP of the frontend"
  value       = module.ec2.frontend_private_ip
}

output "frontend_public_ip" {
  description = "Public IP of the bastion — use this to SSH in"
  value       = module.ec2.frontend_public_ip
}

# Uncomment when the backend EC2 is added to Terraform and module.ec2.backend_private_ip is defined.
# This IP is used by the nginx reverse proxy on the frontend EC2 to forward /v1/api/* requests.
# output "backend_private_ip" {
#   description = "Private IP of the backend EC2 instance"
#   value       = module.ec2.backend_private_ip
# }
