#!/bin/bash

# Set locale for UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Update package list and install dependencies
echo "Updating package list..."
sudo apt-get update

echo "Installing Node.js, npm, and AWS CLI..."
 sudo apt-get install -y --no-install-recommends nodejs npm awscli

echo "Dependencies installed successfully."
