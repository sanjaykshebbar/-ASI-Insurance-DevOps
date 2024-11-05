#!/bin/bash

# Fetch the public IP address of the Jenkins EC2 instance from Terraform output
INSTANCE_IP=$(terraform output -raw instance_public_ip)

# Create or update the Ansible hosts file
cat <<EOL > hosts.ini
[jenkins]
$INSTANCE_IP ansible_ssh_private_key_file=/path/to/your/private/key ansible_user=ec2-user
EOL

echo "Updated hosts.ini with the new instance IP: $INSTANCE_IP"
