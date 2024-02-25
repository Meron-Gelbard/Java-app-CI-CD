#!/bin/bash

region=$1
creds=$2
bucket=$3
table=$4


cat << EOF > ../IaC_app/providers.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
  
  backend "s3" {
    bucket         = "$bucket"
    key            = "tf_backend/terraform.tfstate"
    region         = "$region"
    dynamodb_table = "$table"
    encrypt        = true
    shared_credentials_files = ["$creds"]
    profile                 = "default"
  }
}
provider "aws" {
  region     = "$region"
  shared_credentials_files = ["$creds"]
  profile                 = "default"
}
EOF