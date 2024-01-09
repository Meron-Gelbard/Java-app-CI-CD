terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
  }
  backend "s3" {
    bucket         = "javaapp-terraform-backend"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
    profile                 = "default"
  }
}
provider "aws" {
  region     = "us-east-1"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
}
