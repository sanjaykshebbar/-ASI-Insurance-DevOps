provider "aws" {
  region     = "us-east-1"   # Update as per your region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

resource "aws_instance" "jenkins_instance" {
  ami           = "ami-08e4e35cccc6189f4"   # Amazon Linux 2 AMI ID (you can change this to another one)
  instance_type = "t2.micro"
  key_name      = var.AWS_KEY_PAIR_NAME      # Ensure this key pair exists

  tags = {
    Name = "Jenkins-EC2"
  }

  # Add a security group that allows SSH and HTTP
  security_groups = [aws_security_group.jenkins_sg.name]
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.jenkins_instance.public_ip
}
