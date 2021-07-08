
provider "aws" {
  region  = "ap-northeast-1"
  version = "3.48.0"
}

terraform {
  backend "s3" {
    bucket = ""
    key    = "example/terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_version = "0.13.2"
}
