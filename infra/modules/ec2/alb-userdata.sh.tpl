#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx

useradd --system --shell /bin/bash --home /home/deploy --create-home deploy

mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
echo "${deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

rm -f /etc/nginx/sites-enabled/default

cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80 default_server;
    server_name _;

    server_tokens off;

    location /v1/api/ {
        proxy_pass http://${backend_private_ip}:8080/v1/api/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_connect_timeout 5s;
        proxy_send_timeout 30s;
        proxy_read_timeout 60s;
    }

    location = /healthz {
        return 200 "ok\n";
        add_header Content-Type text/plain;
    }
}
EOF

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd

systemctl enable nginx
systemctl start nginx
