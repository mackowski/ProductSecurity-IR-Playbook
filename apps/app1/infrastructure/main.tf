terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

locals {
  app_name = "app1"  # Change this for each app
  ecr_repository_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-west-2.amazonaws.com/${local.app_name}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_iam_role" "app_runner" {
  name = "${local.app_name}-app-runner-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_runner_ecr_policy" {
  role       = aws_iam_role.app_runner.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_apprunner_service" "example" {
  service_name = "${local.app_name}-service"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = "${local.ecr_repository_url}:latest"
      image_repository_type = "ECR"
    }
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner.arn
    }
  }
}

output "app_url" {
  value = aws_apprunner_service.example.service_url
} 