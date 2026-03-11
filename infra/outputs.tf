output "rabbitmq_private_ip" {
  value = module.ec2.services_private_ip
}

output "frontend_public_ip" {
  value = module.ec2.frontend_public_ip
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

output "frontend_instance_id" {
  value = module.ec2.frontend_instance_id
}

# output "cloudfront_domain_name" {
#   value = module.cloudfront.cloudfront_domain_url
# }

# output "cloudfront_distribution_id" {
#   value = module.cloudfront.cloudfront_distribution_id
# }

# output "frontend_bucket_name" {
#   value = module.s3.frontend_bucket_name
# }
