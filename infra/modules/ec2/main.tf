resource "aws_instance" "alb_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.alb_instance_type

  subnet_id              = var.alb_subnet_id
  vpc_security_group_ids = [var.alb_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/alb-userdata.sh.tpl", {
    deploy_public_key = var.deploy_public_key
    core_backend_ips  = [for i in aws_instance.backend : i.private_ip]
  })

  tags = {
    Name = "${var.env}-alb-instance"
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

  user_data = templatefile("${path.module}/rabbitmq-userdata.sh.tpl", {
    rabbitmq_password = var.rabbitmq_password
    rabbitmq_user     = var.rabbitmq_user
  })

  tags = {
    Name = "${var.env}-services-instance"
    Env  = var.env
  }
}

resource "aws_instance" "backend" {
  for_each      = toset(["1", "2"])
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.backend_instance_type

  subnet_id              = var.backend_subnet_id
  vpc_security_group_ids = [var.backend_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/backend-userdata.sh.tpl", {
    deploy_public_key = var.deploy_public_key
  })

  tags = {
    Name = "${var.env}-core-${each.key}"
    Env  = var.env
  }
}

resource "aws_instance" "notification" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.backend_instance_type

  subnet_id              = var.backend_subnet_id
  vpc_security_group_ids = [var.backend_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/backend-userdata.sh.tpl", {
    deploy_public_key = var.deploy_public_key
  })

  tags = {
    Name = "${var.env}-notification"
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

  user_data = templatefile("${path.module}/database-userdata.sh.tpl", {
    db_username = var.db_username
    db_password = var.db_password
  })

  tags = {
    Name = "${var.env}-database-instance"
    Env  = var.env
  }
}

resource "aws_instance" "observability_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.observability_instance_type

  subnet_id              = var.observability_subnet_id
  vpc_security_group_ids = [var.observability_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/observability-userdata.sh.tpl", {

  })

  tags = {
    Name = "${var.env}-observability-instance"
    Env  = var.env
  }
}

resource "aws_eip" "alb" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-alb-eip"
    Env  = var.env
  }
}

resource "aws_eip_association" "alb" {
  instance_id   = aws_instance.alb_instance.id
  allocation_id = aws_eip.alb.id
}
