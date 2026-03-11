#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io docker-compose-v2

systemctl enable docker
systemctl start docker

useradd --system --shell /bin/bash --home /home/deploy --create-home deploy
usermod -aG docker deploy

mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
echo "${var.deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

mkdir -p /opt/app
chown -R deploy:deploy /opt/app

echo "deploy ALL=(ALL) NOPASSWD: /usr/bin/docker, /usr/bin/docker compose *" \
  > /etc/sudoers.d/deploy-docker
chmod 440 /etc/sudoers.d/deploy-docker

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd
