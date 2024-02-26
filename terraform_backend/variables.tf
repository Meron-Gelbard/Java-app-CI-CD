variable "aws_region" {
    default = "us-east-1"
}
variable "aws_credentials" {
    default = "~/.aws/credentials"
}
variable "backend_lock_name" {
    default = "java-app-tf-lock"
}
variable "backend_bucket_name" {
    default = "java-app-tf-backend"
}
variable check_existing_resources {
    default = true
}