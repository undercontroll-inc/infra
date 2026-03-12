#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y docker.io docker-compose-v2 unzip curl

# Install AWS CLI
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

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

echo "deploy ALL=(ALL) NOPASSWD: /usr/bin/docker, /usr/bin/docker compose *" \
  > /etc/sudoers.d/deploy-docker
chmod 440 /etc/sudoers.d/deploy-docker

sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

# Fetch secrets from SSM Parameter Store
export AWS_REGION="us-east-1"

# Create .env file from SSM parameters
cat > /opt/app/.env << 'EOF'
DB_HOST=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/DB_HOST" --query "Parameter.Value" --output text)
DB_USERNAME=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/DB_USERNAME" --with-decryption --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/DB_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
RABBITMQ_HOST=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/RABBITMQ_HOST" --query "Parameter.Value" --output text)
RABBITMQ_USER=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/RABBITMQ_USER" --with-decryption --query "Parameter.Value" --output text)
RABBITMQ_PASSWORD=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/RABBITMQ_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
JWT_SECRET=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/JWT_SECRET" --with-decryption --query "Parameter.Value" --output text)
MAIL_HOST=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/MAIL_HOST" --query "Parameter.Value" --output text)
MAIL_PORT=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/MAIL_PORT" --query "Parameter.Value" --output text)
MAIL_USERNAME=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/MAIL_USERNAME" --with-decryption --query "Parameter.Value" --output text)
MAIL_PASSWORD=$(aws ssm get-parameter --name "/undercontroll/${env}/backend/MAIL_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
EOF

chmod 600 /opt/app/.env
