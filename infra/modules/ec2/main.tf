resource "aws_instance" "frontend_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.services_instance_type

  subnet_id              = var.frontend_subnet_id
  vpc_security_group_ids = [var.frontend_security_group_id]
  key_name               = var.key_pair_name

  # Replace the instance whenever user_data changes (e.g. key rotation)
  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Wait for cloud-init's own apt operations to finish before touching the lock
    systemd-run --property="After=cloud-init.service" --wait true 2>/dev/null || true
    while fuser /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock >/dev/null 2>&1; do
      sleep 2
    done

    apt-get update -y
    apt-get install -y nginx

    # Create a dedicated OS user for CI/CD deployments.
    # It has no login shell escalation — only nginx reload is permitted via sudo.
    useradd --system --shell /bin/bash --home /home/deploy --create-home deploy

    mkdir -p /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    echo "${var.deploy_public_key}" > /home/deploy/.ssh/authorized_keys
    chmod 600 /home/deploy/.ssh/authorized_keys
    chown -R deploy:deploy /home/deploy/.ssh

    chown -R deploy:deploy /usr/share/nginx/html

    echo "deploy ALL=(ALL) NOPASSWD: /usr/sbin/nginx -t, /usr/sbin/nginx -s reload" \
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

  # Replace the instance whenever user_data changes (e.g. credential rotation)
  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Wait for cloud-init's own apt operations to finish before touching the lock
    systemd-run --property="After=cloud-init.service" --wait true 2>/dev/null || true
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
