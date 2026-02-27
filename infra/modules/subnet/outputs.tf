output "frontend_public_subnet_id" {
  value = aws_subnet.frontend_public.id
}

output "services_private_subnet_id" {
  value = aws_subnet.services_private.id
}

output "backend_private_subnet_id" {
  value = aws_subnet.backend_private.id
}

output "database_private_subnet_id" {
  value = aws_subnet.database_private.id
}
