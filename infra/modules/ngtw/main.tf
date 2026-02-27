resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat-eip"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${var.env}-nat-gw"
    Env  = var.env
  }
}
