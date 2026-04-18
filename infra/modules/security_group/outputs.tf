output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "backend_sg_id" {
  value = aws_security_group.backend.id
}

output "services_sg_id" {
  value = aws_security_group.services.id
}

output "database_sg_id" {
  value = aws_security_group.database.id
}
