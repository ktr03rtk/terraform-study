provider "aws" {
  region  = "ap-northeast-1"
  version = "3.48.0"
}

terraform {
  required_version = "0.13.2"
}

resource "aws_s3_bucket" "prevent_destroy_bucket" {
  bucket = "trial-prevent-destroy-pragmatic-terraform"

  lifecycle {
    prevent_destroy = true
  }
}

