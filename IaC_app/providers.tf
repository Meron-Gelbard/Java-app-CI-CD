terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.2"
    }
  }
  
  backend "s3" {
    bucket         = "java-app-tf-backend"
    key            = "tf_backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "java-app-tf-lock"
    encrypt        = true
    shared_credentials_file = "/Users/merongelbard/.aws/credentials"
    profile                 = "default"
  }
}
provider "aws" {
  region     = "us-east-1"
  shared_credentials_file = "/Users/merongelbard/.aws/credentials"
  profile                 = "default"
}
