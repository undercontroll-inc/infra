output "rabbitmq_private_ip" {
  description = "Private IP of the RabbitMQ EC2 instance. Use this as the AMQP host in backend and notification-api (spring.rabbitmq.host)"
  value       = module.ec2.private_ip
}
