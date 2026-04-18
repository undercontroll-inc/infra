# Route table para a subnet publica, fazendo a conexão com o igw para o trafego
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.env}-public-rt"
    Env  = var.env
  }
}

resource "aws_route_table_association" "alb_public" {
  subnet_id      = var.alb_public_subnet_id
  route_table_id = aws_route_table.public.id
}

# Route table para subnets privadas, fazendo a conexão com o nat gateway para o trafego
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${var.env}-private-rt"
    Env  = var.env
  }
}

resource "aws_route_table_association" "services_private" {
  subnet_id      = var.services_private_subnet_id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "backend_private" {
  subnet_id      = var.backend_private_subnet_id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database_private" {
  subnet_id      = var.database_private_subnet_id
  route_table_id = aws_route_table.private.id
}
