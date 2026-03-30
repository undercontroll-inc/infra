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

module "s3" {
  source = "./modules/s3"
  env    = var.env
}
