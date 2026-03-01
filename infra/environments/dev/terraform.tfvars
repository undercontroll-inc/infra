env    = "dev"
region = "us-east-1"

bucket_name = "undercontroll-tfstate-dev"

vpc_cidr_block               = "10.1.0.0/16"
frontend_public_subnet_cidr  = "10.1.1.0/24"
services_private_subnet_cidr = "10.1.2.0/24"
backend_private_subnet_cidr  = "10.1.3.0/24"
database_private_subnet_cidr = "10.1.4.0/24"

backend_port = 8080
