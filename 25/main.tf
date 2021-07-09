provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "imported" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_security_group" "web_server" {
  name        = "web-server"
  description = "Example"
}