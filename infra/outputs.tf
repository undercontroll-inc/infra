output "rabbitmq_private_ip" {
  value = module.ec2.services_private_ip
}

output "alb_public_ip" {
  value = module.ec2.alb_public_ip
}

output "backend_private_ip" {
  value = module.ec2.backend_private_ip
}

output "database_private_ip" {
  value = module.ec2.database_private_ip
}

output "backend_instance_id" {
  value = module.ec2.backend_instance_id
}

output "alb_instance_id" {
  value = module.ec2.alb_instance_id
}

output "export_bucket_name" {
  value = module.s3.export_bucket_name
}

output "frontend_bucket_name" {
  value = module.frontend_cdn.bucket_name
}

output "cloudfront_distribution_id" {
  value = module.frontend_cdn.distribution_id
}

output "cloudfront_domain_name" {
  value = module.frontend_cdn.domain_name
}
