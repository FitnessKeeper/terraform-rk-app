terraform {
  required_version = "~> 1.0.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.46.0"
    }
  }
}

provider "aws" {
  alias   = "us-west-1"
}

provider "aws" {
  alias   = "us-east-1"
}
