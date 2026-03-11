# resource "aws_instance" "frontend_instance" {
#   ami           = data.aws_ami.ubuntu_ami.id
#   instance_type = var.frontend_instance_type

#   subnet_id              = var.frontend_subnet_id
#   vpc_security_group_ids = [var.frontend_security_group_id]
#   key_name               = var.key_pair_name

#   user_data_replace_on_change = true

#   user_data = <<-EOF
# #!/bin/bash
# set -e

# while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock >/dev/null 2>&1; do
#   sleep 2
# done

# apt-get update -y
# apt-get install -y nginx

# useradd --system --shell /bin/bash --home /home/deploy --create-home deploy

# mkdir -p /home/deploy/.ssh
# chmod 700 /home/deploy/.ssh
# echo "${var.deploy_public_key}" > /home/deploy/.ssh/authorized_keys
# chmod 600 /home/deploy/.ssh/authorized_keys
# chown -R deploy:deploy /home/deploy/.ssh

# chown -R deploy:deploy /usr/share/nginx/html

# echo "deploy ALL=(ALL) NOPASSWD: /usr/sbin/nginx -t, /usr/sbin/nginx -s reload, /usr/bin/envsubst" \
#   > /etc/sudoers.d/deploy-nginx
# chmod 440 /etc/sudoers.d/deploy-nginx

# sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
# sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
# systemctl reload sshd

# systemctl enable nginx
# systemctl start nginx
# EOF

#   tags = {
#     Name = "${var.env}-frontend-instance"
#     Env  = var.env
#   }
# }

# resource "aws_instance" "services_instance" {
#   ami           = data.aws_ami.ubuntu_ami.id
#   instance_type = var.services_instance_type

#   subnet_id              = var.services_subnet_id
#   vpc_security_group_ids = [var.services_security_group_id]
#   key_name               = var.key_pair_name

#   user_data_replace_on_change = true


#   user_data = file("../../scripts/rabbitmq-userdata.sh")

#   tags = {
#     Name = "${var.env}-services-instance"
#     Env  = var.env
#   }
# }

# resource "aws_instance" "backend_instance" {
#   ami           = data.aws_ami.ubuntu_ami.id
#   instance_type = var.backend_instance_type

#   subnet_id              = var.backend_subnet_id
#   vpc_security_group_ids = [var.backend_security_group_id]
#   key_name               = var.key_pair_name

#   user_data_replace_on_change = true

#   user_data = file("../../scripts/backend-userdata.sh")
#   tags = {
#     Name = "${var.env}-backend-instance"
#     Env  = var.env
#   }
# }

# resource "aws_instance" "database_instance" {
#   ami           = data.aws_ami.ubuntu_ami.id
#   instance_type = var.database_instance_type

#   subnet_id              = var.database_subnet_id
#   vpc_security_group_ids = [var.database_security_group_id]
#   key_name               = var.key_pair_name

#   user_data_replace_on_change = true

#   user_data = file("../../scripts/rabbitmq-userdata.sh")

#   tags = {
#     Name = "${var.env}-database-instance"
#     Env  = var.env
#   }
# }
#
#

resource "aws_instance" "frontend_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.frontend_instance_type

  subnet_id              = var.frontend_subnet_id
  vpc_security_group_ids = [var.frontend_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
set -e

while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock >/dev/null 2>&1; do
  sleep 2
done

apt-get update -y
apt-get install -y nginx

useradd --system --shell /bin/bash --home /home/deploy --create-home deploy

mkdir -p /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
echo "${var.deploy_public_key}" > /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

chown -R deploy:deploy /usr/share/nginx/html

echo "deploy ALL=(ALL) NOPASSWD: /usr/sbin/nginx -t, /usr/sbin/nginx -s reload, /usr/bin/envsubst" \
  > /etc/sudoers.d/deploy-nginx
chmod 440 /etc/sudoers.d/deploy-nginx

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd

systemctl enable nginx
systemctl start nginx
EOF

  tags = {
    Name = "${var.env}-frontend-instance"
    Env  = var.env
  }
}

resource "aws_instance" "services_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.services_instance_type

  subnet_id              = var.services_subnet_id
  vpc_security_group_ids = [var.services_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
set -e

while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock >/dev/null 2>&1; do
  sleep 2
done

apt-get update -y
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

docker run -d \
  --name rabbitmq \
  --restart unless-stopped \
  -p 5672:5672 \
  -p 15672:15672 \
  -e "RABBITMQ_DEFAULT_USER=${var.rabbitmq_user}" \
  -e "RABBITMQ_DEFAULT_PASS=${var.rabbitmq_password}" \
  rabbitmq:management-alpine
EOF

  tags = {
    Name = "${var.env}-services-instance"
    Env  = var.env
  }
}

resource "aws_instance" "backend_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.backend_instance_type

  subnet_id              = var.backend_subnet_id
  vpc_security_group_ids = [var.backend_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
set -e

systemd-run --property="After=cloud-init.service" --wait true 2>/dev/null || true
while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock >/dev/null 2>&1; do
  sleep 2
done

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
EOF

  tags = {
    Name = "${var.env}-backend-instance"
    Env  = var.env
  }
}

resource "aws_instance" "database_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.database_instance_type

  subnet_id              = var.database_subnet_id
  vpc_security_group_ids = [var.database_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
set -e

systemd-run --property="After=cloud-init.service" --wait true 2>/dev/null || true
while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock >/dev/null 2>&1; do
  sleep 2
done

apt-get update -y
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

mkdir -p /data/postgres

docker run -d \
  --name postgres \
  --restart unless-stopped \
  -p 5432:5432 \
  -v /data/postgres:/var/lib/postgresql/data \
  -e "POSTGRES_DB=undercontroll" \
  -e "POSTGRES_USER=${var.db_username}" \
  -e "POSTGRES_PASSWORD=${var.db_password}" \
  postgres:16-alpine
EOF

  tags = {
    Name = "${var.env}-database-instance"
    Env  = var.env
  }
}
