#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx rsync

useradd --system --shell /bin/bash --home /home/deploy --create-home deploy

mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
echo "${deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

mkdir -p /var/www/frontend
chown -R deploy:deploy /var/www/frontend

cat > /var/www/frontend/index.html <<'HTML'
<!doctype html><html><body><h1>undercontroll — aguardando primeiro deploy</h1></body></html>
HTML
chown deploy:deploy /var/www/frontend/index.html

# permite que deploy recarregue nginx sem senha (necessário para o CD)
echo 'deploy ALL=(ALL) NOPASSWD: /usr/sbin/nginx, /usr/bin/systemctl' > /etc/sudoers.d/deploy
chmod 440 /etc/sudoers.d/deploy

rm -f /etc/nginx/sites-enabled/default

cat > /etc/nginx/conf.d/default.conf <<'EOF'
upstream core {
%{ for ip in core_backend_ips ~}
    server ${ip}:8080;
%{ endfor ~}
}

server {
    listen 80 default_server;
    server_name _;
    server_tokens off;

    root /var/www/frontend;
    index index.html;

    location = /healthz {
        return 200 "ok\n";
        add_header Content-Type text/plain;
    }

    location /v1/api/ {
        proxy_pass http://core;
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

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd

systemctl enable nginx
systemctl restart nginx
