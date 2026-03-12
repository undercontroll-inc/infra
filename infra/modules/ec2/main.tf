resource "aws_instance" "frontend_instance" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.frontend_instance_type

  subnet_id              = var.frontend_subnet_id
  vpc_security_group_ids = [var.frontend_security_group_id]
  key_name               = var.key_pair_name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/frontend-userdata.sh.tpl", {
    deploy_public_key = var.deploy_public_key
  })

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


  user_data = templatefile("${path.module}/rabbitmq-userdata.sh.tpl", {
    rabbitmq_password = var.rabbitmq_password
    rabbitmq_user     = var.rabbitmq_user
  })

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
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/backend-userdata.sh.tpl", {
    deploy_public_key = var.deploy_public_key
    env               = var.env
  })

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


  user_data = templatefile("${path.module}/database-userdata.sh.tpl", {
    db_username = var.db_username
    db_password = var.db_password
  })

  tags = {
    Name = "${var.env}-database-instance"
    Env  = var.env
  }
}

# IAM Role for EC2 to access SSM Parameter Store
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.env}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
