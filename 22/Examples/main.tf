provider "aws" {
  region  = "ap-northeast-1"
  version = "3.48.0"
}

terraform {
  required_version = "0.13.2"
  required_providers {
    aws = ">=3.48.0"
  }
}

module "security_groups" {
  source      = "./modules/security_group"
  name        = "example"
  vpc_id      = aws_vpc.example.id
  port        = 80
  cidr_blocks = [aws_vpc.example.cidr_block]

}

resource "aws_vpc" "example" {
  cidr_block = var.cidr_block
}
