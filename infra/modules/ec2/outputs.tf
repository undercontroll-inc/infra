output "services_instance_id" {
  value = aws_instance.services_instance.id
}

output "services_private_ip" {
  value = aws_instance.services_instance.private_ip
}

output "alb_instance_id" {
  value = aws_instance.alb_instance.id
}

output "alb_private_ip" {
  value = aws_instance.alb_instance.private_ip
}

output "alb_public_ip" {
  value = aws_eip.alb.public_ip
}

output "alb_eip_public_ip" {
  value = aws_eip.alb.public_ip
}

output "alb_eip_public_dns" {
  value = aws_eip.alb.public_dns
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
