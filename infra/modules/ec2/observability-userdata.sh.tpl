#!/bin/bash

set -e

PROM_CONFIG_DIR="/etc/prometheus"
PROM_CONFIG_FILE="${PROM_CONFIG_DIR}/prometheus.yml"
sudo apt-get update -y
sudo apt-get install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

echo "Running Grafana..."

sudo docker run  --name=grafana grafana/grafana:main-ubuntu -p 3000:3000 --restart unless-stopped -d

echo "Running Prometheus..."

sudo mkdir -p ${PROM_CONFIG_DIR}

docker run -d \
  --name prometheus \
  --restart unless-stopped \
  -p 9090:9090 \
  -v ${PROM_CONFIG_FILE}:/etc/prometheus/prometheus.yml \
  -v prometheus_data:/prometheus \
  prom/prometheus
