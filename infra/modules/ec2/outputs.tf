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

output "core_instance_ids" {
  value = [for i in aws_instance.backend : i.id]
}

output "core_private_ips" {
  value = [for i in aws_instance.backend : i.private_ip]
}

output "notification_instance_id" {
  value = aws_instance.notification.id
}

output "notification_private_ip" {
  value = aws_instance.notification.private_ip
}

output "database_instance_id" {
  value = aws_instance.database_instance.id
}

output "database_private_ip" {
  value = aws_instance.database_instance.private_ip
}

output "observability_public_ip" {
  value = aws_eip.observability.public_ip
}
