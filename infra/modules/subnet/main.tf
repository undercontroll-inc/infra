resource "aws_subnet" "alb_public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.alb_public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-alb-public"
    Env  = var.env
  }
}

resource "aws_subnet" "services_private" {
  vpc_id     = var.vpc_id
  cidr_block = var.services_private_subnet_cidr

  tags = {
    Name = "${var.env}-services-private"
    Env  = var.env
  }
}

resource "aws_subnet" "backend_private" {
  vpc_id     = var.vpc_id
  cidr_block = var.backend_private_subnet_cidr

  tags = {
    Name = "${var.env}-backend-private"
    Env  = var.env
  }
}

resource "aws_subnet" "database_private" {
  vpc_id     = var.vpc_id
  cidr_block = var.database_private_subnet_cidr

  tags = {
    Name = "${var.env}-database-private"
    Env  = var.env
  }
}

resource "aws_subnet" "observability_public" {
  vpc_id     = var.vpc_id
  cidr_block = var.observability_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-observability"
    Env  = var.env
  }
}
