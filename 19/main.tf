provider "aws" {
  region  = "ap-northeast-1"
  version = "3.48.0"
}

terraform {
  required_version = "0.13.2"
}

// ternary operator
variable "env" {}

resource "aws_instance" "example" {
  ami           = "ami-0c3fd0f5d33134a76"
  instance_type = var.env == "prod" ? "m5.large" : "t3.micro"
}

// multiple resource
resource "aws_vpc" "example" {
  count      = 2
  cidr_block = "10.${count.index}.0.0/16"
}

// generation control
module "allow_ssh" {
  source         = "./security_group"
  allow_ssh      = true
  allow_ssh_name = "example_true"
}

output "allow_ssh_rule_id" {
  value = module.allow_ssh.allow_ssh_rule_id
}

module "disallow_ssh" {
  source         = "./security_group"
  allow_ssh      = false
  allow_ssh_name = "example_false"
}

output "disallow_ssh_rule_id" {
  value = module.disallow_ssh.allow_ssh_rule_id
}

// data source
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

data "aws_region" "current" {}

output "region_name" {
  value = data.aws_region.current.name
}

data "aws_availability_zone" "available" {
  state = "available"
  name  = "ap-northeast-1a"
}

output "availability_zones" {
  value = data.aws_availability_zone.available.name
}

data "aws_elb_service_account" "current" {}

output "alb_service_account_id" {
  value = data.aws_elb_service_account.current.id
}

// template
//templatefile("${path.module}/install.sh"

// random string
provider "random" {}

resource "random_string" "password" {
  length  = 32
  special = false
}

resource "aws_db_instance" "example" {
  engine              = "mysql"
  instance_class      = "db.t3.small"
  allocated_storage   = 20
  skip_final_snapshot = true
  username            = "admin"
  password            = random_string.password.result
}

// multiple provider
provider "aws" {
  alias  = "virginia"
  region = "ap-northeast-2"
}

resource "aws_vpc" "virginia" {
  provider   = aws.virginia
  cidr_block = "192.168.0.0/16"
}

resource "aws_vpc" "tokyo" {
  cidr_block = "192.168.0.0/16"
}

output "tokyo_vpc" {
  value = aws_vpc.tokyo.arn
}

module "virginia" {
  source = "./vpc"

  providers = {
    aws = aws.virginia
  }
}

module "tokyo" {
  source = "./vpc"
}

output "module_virginia_vpc" {
  value = module.virginia.vpc_arn
}

output "module_tokyo_vpc" {
  value = module.tokyo.vpc_arn
}

// dynamic blocks
module "simple_sg" {
  source = "./simple_security_group"
  ports  = [80, 443, 8080]
}

module "complex_sg" {
  source = "./complex_security_group"
  ingress_rules = {
    http = {
      port        = 80
      cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    }
    https = {
      port        = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
    redirect_http_to_https = {
      port        = 8080
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
