
resource "aws_security_group" "JAVA-APP-sg" {
  name        = "JAVA-APP-sg"
  description = "Allow SSH"
  vpc_id      = "vpc-05984e1e104d4023b"

  ingress {
    description      = "allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "java-app-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "null_resource" "save_private_key" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.ec2_key.private_key_pem}' > java-app.pem"
  }
}

resource "aws_instance" "java-app" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = "subnet-020b671b71c37c581"
  vpc_security_group_ids = [aws_security_group.JAVA-APP-sg.id]
  key_name               = "java-app-key"
  tags = {
    Name = "java-app"
  }

  provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt-get install -y docker.io",
        "sudo systemctl start docker",
        "sudo usermod -aG docker ubuntu",
        "sudo apt-get install -y git",
        "sudo systemctl enable docker",
        "sudo docker login --username=${var.dockerhub_username} --password=${var.dockerhub_password}",
        "sudo docker pull ${var.dockerhub_username}/java-app:latest",
        "sudo docker run -d ${var.dockerhub_username}/java-app:latest",
      ]

      connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("java-app.pem")
        host        = self.public_ip
        }
    }
}
