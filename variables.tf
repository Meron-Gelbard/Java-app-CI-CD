variable "dockerhub_username" {
  description = "Docker Hub username"
}

variable "dockerhub_password" {
  description = "Docker Hub password"
}

variable "app_version" {
  description = "1.0.0"
}

variable "vpc_id" {
  description = "vpc id"
}

variable "subnet_id" {
  description = "subnet id"
}

variable "aws_region" {
  description = "aws region"
}

provider "external" {
  version = "1.2.0"
}

data "external" "ip_script_output" {
  program = ["python3", "${path.module}/ec2_connect_ip_script.py", "${var.aws_region}"]
}

variable "ec2_connect_ip" {
  type    = string
  default = "${data.external.ip_script_output.result}"
}
