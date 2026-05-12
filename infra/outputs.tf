output "rabbitmq_private_ip" {
  value = module.ec2.services_private_ip
}

output "alb_public_ip" {
  value = module.ec2.alb_public_ip
}

output "alb_instance_id" {
  value = module.ec2.alb_instance_id
}

output "core_private_ips" {
  value = module.ec2.core_private_ips
}

output "core_instance_ids" {
  value = module.ec2.core_instance_ids
}

output "notification_private_ip" {
  value = module.ec2.notification_private_ip
}

output "notification_instance_id" {
  value = module.ec2.notification_instance_id
}

output "database_private_ip" {
  value = module.ec2.database_private_ip
}

output "observability_public_ip" {
  value = module.ec2.observability_public_ip
}

output "name" {
  value = module.ec2.name
}

output "export_bucket_name" {
  value = module.s3.export_bucket_name
}
