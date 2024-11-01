output "instance_ip" {
  value = aws_instance.my_ec2_instance.public_ip
  description = "Public IP of the EC2 instance"
}

