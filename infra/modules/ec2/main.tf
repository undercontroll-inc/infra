resource "aws_instance" "frontend_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.frontend_instance_type

  subnet_id              = var.frontend_subnet_id
  vpc_security_group_ids = [var.frontend_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = file("${path.module}/frontend-userdata.sh")

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


  user_data = file("${path.module}/rabbitmq-userdata.sh")

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

  user_data = file("${path.module}/backend-userdata.sh")

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


  user_data = file("${path.module}/database-userdata.sh")

  tags = {
    Name = "${var.env}-database-instance"
    Env  = var.env
  }
}
