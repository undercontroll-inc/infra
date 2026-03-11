
#!/bin/bash

set -e

apt-get update -y
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

docker run -d \
  --name rabbitmq \
  --restart unless-stopped \
  -p 5672:5672 \
  -p 15672:15672 \
  -e "RABBITMQ_DEFAULT_USER=${var.rabbitmq_user}" \
  -e "RABBITMQ_DEFAULT_PASS=${var.rabbitmq_password}" \
  rabbitmq:management-alpine
