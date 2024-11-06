provider "aws" {
  region = "us-east-1"  # Update as per your region
}

resource "aws_instance" "jenkins_instance" {
  ami           = "ami-08e4e35cccc6189f4"   # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  key_name      = var.AWS_KEY_PAIR_NAME     # Ensure this key pair exists

  tags = {
    Name = "Jenkins-EC2"
  }

  # Associate security group
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  # Add user data to install Docker automatically on instance launch
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -aG docker ec2-user
              EOF
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider limiting this to your own IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider limiting this to your own IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}

variable "AWS_KEY_PAIR_NAME" {
  type        = string
  description = "Name of the existing AWS key pair"
}
