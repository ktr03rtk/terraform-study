resource "aws_instance" "server" {
  ami                    = "ami-0c3fd0f5d33134a76"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
  subnet_id              = module.network.public_subnet_id
}

resource "aws_security_group" "server" {
  vpc_id = module.network.vpc_id
}

module "network" {
  source = "./network"
}