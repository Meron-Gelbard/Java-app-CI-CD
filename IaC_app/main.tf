resource "aws_vpc" "app_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.app_name}-internet-gw"
  }
}

resource "aws_route_table" "igw-rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.app_name}-igw-route-table"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-sn"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
 subnet_id      = aws_subnet.public.id
 route_table_id = aws_route_table.igw-rt.id
}

resource "aws_security_group" "JAVA-APP-sg" {
  name        = "${var.app_name}-sg"
  description = "Allow SSH from EC2 connect service"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description      = "Allow SSH from EC2 connect"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.ec2_connect_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "JAVA-APP-sg"
  }
}

resource "aws_instance" "java-app" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "${var.instance_type}"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.JAVA-APP-sg.id]
  tags = {
    Name = "${var.app_name}-${var.app_version}"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo usermod -aG docker ubuntu
              sudo apt-get install -y git
              sudo systemctl enable docker
              sudo docker login --username=${var.dockerhub_username} --password=${var.dockerhub_password}
              sudo docker pull ${var.dockerhub_username}/java-app:latest
              sudo docker run -d ${var.dockerhub_username}/java-app:latest
              EOF
}