output "instance_id" {
  description = "ID of the services EC2 instance"
  value       = aws_instance.services_instance.id
}

output "private_ip" {
  description = "Private IP of the services EC2 instance"
  value       = aws_instance.services_instance.private_ip
}
