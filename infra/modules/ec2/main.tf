resource "aws_instance" "frontend_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.services_instance_type

  subnet_id              = var.frontend_subnet_id
  vpc_security_group_ids = [var.frontend_security_group_id]
  key_name               = var.key_pair_name

  # Replace the instance whenever user_data changes (e.g. credential rotation)
  user_data_replace_on_change = true

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
