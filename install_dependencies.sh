#!/bin/bash

# Set locale for UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Install NVM (Node Version Manager)
echo "Installing NVM..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
else
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm if already installed
fi

# Install the latest LTS version of Node.js
echo "Installing Node.js (latest LTS version)..."
nvm install --lts

# Verify installation
echo "Node.js and npm versions:"
node -v
npm -v

# Install AWS CLI
echo "Installing AWS CLI..."
sudo apt-get install -y awscli

echo "Dependencies installed successfully."
