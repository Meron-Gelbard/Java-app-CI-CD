
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.2"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  shared_credentials_file = "${var.aws_credentials}"
  profile                 = "default"
}

resource "aws_s3_bucket" "tf-remote-backend" {
    bucket = var.backend_bucket_name
}

resource "aws_dynamodb_table" "backend_lock" {
  name           = var.backend_lock_name
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1  
  billing_mode   = "PROVISIONED"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "null_resource" "update-backend-details" {
  provisioner "local-exec" {
    command = "bash update_tf_backend.sh ${var.aws_region} ${var.aws_credentials} ${var.backend_bucket_name} ${var.backend_lock_name}"
  }
}