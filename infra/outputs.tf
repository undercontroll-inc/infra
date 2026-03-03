output "rabbitmq_private_ip" {
  value = module.ec2.services_private_ip
}

output "frontend_public_ip" {
  value = module.ec2.frontend_public_ip
}

output "backend_private_ip" {
  value = module.ec2.backend_private_ip
}

output "database_private_ip" {
  value = module.ec2.database_private_ip
}
