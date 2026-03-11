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
echo "${var.deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown -R deploy:deploy /home/deploy/.ssh

mkdir -p /opt/app
sudo chown -R deploy:deploy /opt/app

echo "deploy ALL=(ALL) NOPASSWD: /usr/bin/docker, /usr/bin/docker compose *" \
  > /etc/sudoers.d/deploy-docker
chmod 440 /etc/sudoers.d/deploy-docker

sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl reload sshd
