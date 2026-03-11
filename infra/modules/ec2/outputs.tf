output "services_instance_id" {
  value = aws_instance.services_instance.id
}

output "services_private_ip" {
  value = aws_instance.services_instance.private_ip
}

output "frontend_instance_id" {
  value = aws_instance.frontend_instance.id
}

output "frontend_private_ip" {
  value = aws_instance.frontend_instance.private_ip
}

output "frontend_public_ip" {
  value = aws_instance.frontend_instance.public_ip
}

output "backend_instance_id" {
  value = aws_instance.backend_instance.id
}

output "backend_private_ip" {
  value = aws_instance.backend_instance.private_ip
}

output "database_instance_id" {
  value = aws_instance.database_instance.id
}

output "database_private_ip" {
  value = aws_instance.database_instance.private_ip
}
