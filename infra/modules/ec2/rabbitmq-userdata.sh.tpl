#!/bin/bash

set -e

sudo apt-get update -y
sudo apt-get install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo docker run -d \
  --name rabbitmq \
  --restart unless-stopped \
  -p 5672:5672 \
  -p 15672:15672 \
  -e "RABBITMQ_DEFAULT_USER=${rabbitmq_user}" \
  -e "RABBITMQ_DEFAULT_PASS=${rabbitmq_password}" \
  rabbitmq:management-alpine
