#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y docker.io docker-compose-v2

sudo systemctl enable docker
sudo systemctl start docker

sudo useradd --system --shell /bin/bash --home /home/deploy --create-home deploy
sudo usermod -aG docker deploy

mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
echo "${deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown -R deploy:deploy /home/deploy/.ssh

mkdir -p /opt/app
sudo chown -R deploy:deploy /opt/app

mkdir -p /opt/app/nginx
cat > /opt/app/nginx/backend.conf <<'EOF'
server {
    listen 80;
    server_name _;

    server_tokens off;
    client_max_body_size 10m;
    client_body_timeout 15s;
    send_timeout 30s;

    location /v1/api/ {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_connect_timeout 5s;
        proxy_send_timeout 30s;
        proxy_read_timeout 60s;
    }

    location = / {
        return 404;
    }
}
EOF
sudo chown -R deploy:deploy /opt/app/nginx

echo "deploy ALL=(ALL) NOPASSWD: /usr/bin/docker, /usr/bin/docker compose *" \
  > /etc/sudoers.d/deploy-docker
chmod 440 /etc/sudoers.d/deploy-docker

sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl reload sshd
