data "aws_ami" "ubuntu_ami" {
  most_recent = true

  virtualization_type = "hvm"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  # Owner oficial da Cannonical (distribuidora do ubuntu)
  owners = ["099720109477"]
}
