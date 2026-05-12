#!/bin/bash

set -e

PROM_CONFIG_DIR="/etc/prometheus"
PROM_CONFIG_FILE="$PROM_CONFIG_DIR/prometheus.yml"
GRAFANA_PROVISIONING_DIR="/etc/grafana/provisioning"

sudo apt-get update -y
sudo apt-get install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo mkdir -p $PROM_CONFIG_DIR
sudo mkdir -p $GRAFANA_PROVISIONING_DIR/datasources
sudo mkdir -p $GRAFANA_PROVISIONING_DIR/dashboards

cat > $PROM_CONFIG_FILE <<'EOF'
${prometheus_config}
EOF

cat > $GRAFANA_PROVISIONING_DIR/datasources/datasource.yml <<'EOF'
${grafana_datasource_config}
EOF

cat > $GRAFANA_PROVISIONING_DIR/dashboards/dashboards.yml <<'EOF'
${grafana_dashboards_config}
EOF

cat > $GRAFANA_PROVISIONING_DIR/dashboards/spring-metrics.json <<'EOF'
${grafana_dashboard_json}
EOF

sudo docker network create undercontroll-observability || true

echo "Running Prometheus..."

sudo docker run -d \
  --name prometheus \
  --network undercontroll-observability \
  --restart unless-stopped \
  -p 9090:9090 \
  -v $PROM_CONFIG_FILE:/etc/prometheus/prometheus.yml \
  -v prometheus_data:/prometheus \
  prom/prometheus

echo "Running Grafana..."

sudo docker run -d \
  --name grafana \
  --network undercontroll-observability \
  -p 3000:3000 \
  --restart unless-stopped \
  -v $GRAFANA_PROVISIONING_DIR:/etc/grafana/provisioning \
  grafana/grafana:main-ubuntu
