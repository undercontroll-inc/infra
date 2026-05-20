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
  rabbitmq:3-management-alpine

sudo mkdir -p /data/redis

sudo tee /etc/redis-acl.conf > /dev/null <<'ACLEOF'
# Desabilita o usuário "default" (sem senha) por segurança
user default off nopass nocommands

# Usuário com acesso total a todas as chaves, canais e comandos
user ${redis_username} on >${redis_password} ~* &* +@all
ACLEOF

sudo docker run -d \
  --name redis \
  --restart unless-stopped \
  -p 6379:6379 \
  -v /data/redis:/data \
  -v /etc/redis-acl.conf:/usr/local/etc/redis/redis.conf \
  redis:7-alpine \
  redis-server /usr/local/etc/redis/redis.conf
