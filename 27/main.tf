provider "aws" {
  region  = "ap-northeast-1"
  version = "3.48.0"
}

terraform {
  required_version = "0.13.2"
}

module "continuous_codebuild_role" {
  source     = "./iam_role"
  name       = "continuous-apply"
  identifier = "codebuild.amazonaws.com"
  policy     = data.aws_iam_policy.administrator_access.policy
}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "continuous_apply" {
  name         = "continuous-apply"
  service_role = module.continuous_codebuild_role.iam_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "hashicorp/terraform:0.13.2"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/ktr03rtk/terraform-study.git"
  }

  provisioner "local-exec" {
    command = <<-EOF
      aws codebuild import-source-credentials --server-type GITHUB --auth-type PERSONAL_ACCESS_TOKEN --token $GITHUB_TOKEN
    EOF

    environment = {
      GITHUB_TOKEN = data.aws_ssm_parameter.github_token.value
    }
  }
}

data "aws_ssm_parameter" "github_token" {
  name = "/continuous_apply/github_token"
}

resource "aws_codebuild_webhook" "continuous_apply" {
  project_name = aws_codebuild_project.continuous_apply.name

  filter_group {
    filter {
      pattern = "PULL_REQUEST_CREATED"
      type    = "EVENT"
    }
  }

  filter_group {
    filter {
      pattern = "PULL_REQUEST_UPDATED"
      type    = "EVENT"
    }
  }

  filter_group {
    filter {
      pattern = "PULL_REQUEST_REOPENED"
      type    = "EVENT"
    }
  }

  filter_group {
    filter {
      pattern = "PUSH"
      type    = "EVENT"
    }

    filter {
      pattern = "main"
      type    = "HEAD_REF"
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block = "192.168.0.0/16"
}