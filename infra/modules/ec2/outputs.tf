output "services_instance_id" {
  description = "ID of the services EC2 instance"
  value       = aws_instance.services_instance.id
}

output "services_private_ip" {
  description = "Private IP of the services EC2 instance"
  value       = aws_instance.services_instance.private_ip
}

output "frontend_instance_id" {
  description = "ID of the frontend"
  value       = aws_instance.frontend_instance.id
}

output "frontend_private_ip" {
  description = "Private IP of the frontend"
  value       = aws_instance.frontend_instance.private_ip
}

output "frontend_public_ip" {
  description = "Public IP of the bastion — use this to SSH in"
  value       = aws_instance.frontend_instance.public_ip
}
