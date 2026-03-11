#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

mkdir -p /data/postgres

docker run -d \
  --name postgres \
  --restart unless-stopped \
  -p 5432:5432 \
  -v /data/postgres:/var/lib/postgresql/data \
  -e "POSTGRES_DB=undercontroll" \
  -e "POSTGRES_USER=${var.db_username}" \
  -e "POSTGRES_PASSWORD=${var.db_password}" \
  postgres:16-alpine
