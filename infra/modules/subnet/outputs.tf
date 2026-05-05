output "alb_public_subnet_id" {
  value = aws_subnet.alb_public.id
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

output "observability_public_subnet_id" {
  value = aws_subnet.observability_public.id
}
