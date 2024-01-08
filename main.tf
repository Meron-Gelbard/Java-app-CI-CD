
resource "aws_security_group" "JAVA-APP-sg" {
  name        = "JAVA-APP-sg"
  description = "java app SG"
  vpc_id      = "${var.vpc_id}"

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
  instance_type = "t2.micro"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = [aws_security_group.JAVA-APP-sg.id]
  tags = {
    Name = "Java-App-${var.app_version}"
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
