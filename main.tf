provider "aws" {
  region     = "us-east-1"
 }

resource "aws_instance" "asi_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = "your-key-pair-name"
  security_groups = ["${aws_security_group.asi_security_group.name}"]

  tags = {
    Name = "ASI-Insurance-EC2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.asi_ec2.public_ip
}

