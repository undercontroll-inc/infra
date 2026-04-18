env    = "dev"
region = "us-east-1"

vpc_cidr_block               = "10.1.0.0/16"
alb_public_subnet_cidr       = "10.1.1.0/24"
services_private_subnet_cidr = "10.1.2.0/24"
backend_private_subnet_cidr  = "10.1.3.0/24"
database_private_subnet_cidr = "10.1.4.0/24"

backend_port = 8080

# Nome da key pair a ser usada para o ssh nas instancias
key_pair_name = "minha-chave"
