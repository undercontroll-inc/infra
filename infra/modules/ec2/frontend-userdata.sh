#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y nginx

sudo useradd --system --shell /bin/bash --home /home/deploy --create-home deploy

mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
echo "${var.deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown -R deploy:deploy /home/deploy/.ssh

sudo chown -R deploy:deploy /usr/share/nginx/html

echo "deploy ALL=(ALL) NOPASSWD: /usr/sbin/nginx -t, /usr/sbin/nginx -s reload, /usr/bin/envsubst" \
  > /etc/sudoers.d/deploy-nginx
chmod 440 /etc/sudoers.d/deploy-nginx

sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

sudo systemctl enable nginx
sudo systemctl start nginx
