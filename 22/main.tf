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
