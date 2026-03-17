terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Definindo o backend como um s3 para sincronizarmos as alterações na infraestrutura globalmente
  backend "s3" {
    bucket         = "undercontroll-tfstate-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "undercontroll-tfstate-lock-dev"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./modules/vpc"
  env            = var.env
  vpc_cidr_block = var.vpc_cidr_block
}

module "igtw" {
  source = "./modules/igtw"
  env    = var.env
  vpc_id = module.vpc.vpc_id
}

module "subnets" {
  source                       = "./modules/subnet"
  env                          = var.env
  vpc_id                       = module.vpc.vpc_id
  frontend_public_subnet_cidr  = var.frontend_public_subnet_cidr
  services_private_subnet_cidr = var.services_private_subnet_cidr
  backend_private_subnet_cidr  = var.backend_private_subnet_cidr
  database_private_subnet_cidr = var.database_private_subnet_cidr
}

module "ngtw" {
  source           = "./modules/ngtw"
  env              = var.env
  public_subnet_id = module.subnets.frontend_public_subnet_id

  depends_on = [module.igtw]
}

module "route_tables" {
  source                     = "./modules/route_table"
  env                        = var.env
  vpc_id                     = module.vpc.vpc_id
  igw_id                     = module.igtw.igw_id
  nat_gateway_id             = module.ngtw.nat_gateway_id
  frontend_public_subnet_id  = module.subnets.frontend_public_subnet_id
  services_private_subnet_id = module.subnets.services_private_subnet_id
  backend_private_subnet_id  = module.subnets.backend_private_subnet_id
  database_private_subnet_id = module.subnets.database_private_subnet_id
}

module "security_groups" {
  source       = "./modules/security_group"
  env          = var.env
  vpc_id       = module.vpc.vpc_id
  backend_port = var.backend_port
}

module "ec2" {
  source                     = "./modules/ec2"
  env                        = var.env
  frontend_subnet_id         = module.subnets.frontend_public_subnet_id
  services_subnet_id         = module.subnets.services_private_subnet_id
  backend_subnet_id          = module.subnets.backend_private_subnet_id
  database_subnet_id         = module.subnets.database_private_subnet_id
  frontend_security_group_id = module.security_groups.frontend_sg_id
  services_security_group_id = module.security_groups.services_sg_id
  backend_security_group_id  = module.security_groups.backend_sg_id
  database_security_group_id = module.security_groups.database_sg_id
  rabbitmq_user              = var.rabbitmq_user
  rabbitmq_password          = var.rabbitmq_password
  db_username                = var.db_username
  db_password                = var.db_password
  key_pair_name              = var.key_pair_name
  deploy_public_key          = var.deploy_public_key

  depends_on = [module.route_tables]
}

# # SSM Parameters for backend secrets
# resource "aws_ssm_parameter" "db_host" {
#   name        = "/undercontroll/${var.env}/backend/DB_HOST"
#   description = "Database host for backend"
#   type        = "String"
#   value       = module.ec2.database_private_ip
# }

# resource "aws_ssm_parameter" "db_username" {
#   name        = "/undercontroll/${var.env}/backend/DB_USERNAME"
#   description = "Database username for backend"
#   type        = "SecureString"
#   value       = var.db_username
# }

# resource "aws_ssm_parameter" "db_password" {
#   name        = "/undercontroll/${var.env}/backend/DB_PASSWORD"
#   description = "Database password for backend"
#   type        = "SecureString"
#   value       = var.db_password
# }

# resource "aws_ssm_parameter" "rabbitmq_host" {
#   name        = "/undercontroll/${var.env}/backend/RABBITMQ_HOST"
#   description = "RabbitMQ host for backend"
#   type        = "String"
#   value       = module.ec2.services_private_ip
# }

# resource "aws_ssm_parameter" "rabbitmq_user" {
#   name        = "/undercontroll/${var.env}/backend/RABBITMQ_USER"
#   description = "RabbitMQ user for backend"
#   type        = "SecureString"
#   value       = var.rabbitmq_user
# }

# resource "aws_ssm_parameter" "rabbitmq_password" {
#   name        = "/undercontroll/${var.env}/backend/RABBITMQ_PASSWORD"
#   description = "RabbitMQ password for backend"
#   type        = "SecureString"
#   value       = var.rabbitmq_password
# }

# resource "aws_ssm_parameter" "jwt_secret" {
#   name        = "/undercontroll/${var.env}/backend/JWT_SECRET"
#   description = "JWT secret for backend"
#   type        = "SecureString"
#   value       = var.jwt_secret
# }

# resource "aws_ssm_parameter" "mail_host" {
#   name        = "/undercontroll/${var.env}/backend/MAIL_HOST"
#   description = "Mail host for backend"
#   type        = "String"
#   value       = var.mail_host
# }

# resource "aws_ssm_parameter" "mail_port" {
#   name        = "/undercontroll/${var.env}/backend/MAIL_PORT"
#   description = "Mail port for backend"
#   type        = "String"
#   value       = var.mail_port
# }

# resource "aws_ssm_parameter" "mail_username" {
#   name        = "/undercontroll/${var.env}/backend/MAIL_USERNAME"
#   description = "Mail username for backend"
#   type        = "SecureString"
#   value       = var.mail_username
# }

# resource "aws_ssm_parameter" "mail_password" {
#   name        = "/undercontroll/${var.env}/backend/MAIL_PASSWORD"
#   description = "Mail password for backend"
#   type        = "SecureString"
#   value       = var.mail_password
# }

# module "s3" {
#   source = "./modules/s3"
#   env    = var.env
# }

# module "cloudfront" {
#   source               = "./modules/cloudfront"
#   env                  = var.env
#   frontend_bucket_name = module.s3.frontend_bucket_name
# }
