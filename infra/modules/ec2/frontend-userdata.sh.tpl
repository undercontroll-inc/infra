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

mkdir -p /home/deploy/frontend/releases
ln -sfn /home/deploy/frontend/releases /home/deploy/frontend/current
chown -R deploy:deploy /home/deploy/frontend

# Remove the default nginx site that ships with Ubuntu so it does not conflict
# with the custom server block deployed by the CD pipeline.
rm -f /etc/nginx/sites-enabled/default

cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80;
    server_name _;

    root /home/deploy/frontend/current;
    index index.html;

    server_tokens off;
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css application/json application/javascript application/xml text/javascript image/svg+xml;

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

    location ~* \.(?:js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, max-age=31536000, immutable";
        access_log off;
    }

    location = /index.html {
        add_header Cache-Control "no-store, max-age=0";
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

echo "deploy ALL=(ALL) NOPASSWD: \
  /usr/sbin/nginx -t, \
  /usr/sbin/nginx -s reload, \
  /usr/bin/tee /etc/nginx/conf.d/default.conf, \
  /bin/rm -f /etc/nginx/sites-enabled/default" \
  > /etc/sudoers.d/deploy-nginx
chmod 440 /etc/sudoers.d/deploy-nginx

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd

systemctl enable nginx
systemctl start nginx
