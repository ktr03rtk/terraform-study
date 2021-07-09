resource "aws_vpc" "staging" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "public_staging" {
  cidr_block = "192.168.0.0/24"
  vpc_id     = aws_vpc.staging.id
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/staging/vpc/id"
  type  = "String"
  value = aws_vpc.staging.id
}

resource "aws_ssm_parameter" "subnet_id" {
  name  = "/staging/public/subnet/id"
  type  = "String"
  value = aws_subnet.public_staging.id
}
