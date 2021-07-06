variable "instance_type" {
  default = "t3.micro"
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "3.48.0"
}

terraform {
  required_version = "0.13.2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c3fd0f5d33134a76"
  instance_type = var.instance_type
}
