#!/bin/bash
echo "Installing Node.js and dependencies..."

# Update package lists
sudo yum update -y

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

# Install PM2 globally for background process management
sudo npm install -g pm2

echo "Node.js installation completed"
echo "Node.js version: $(node -v)"
echo "NPM version: $(npm -v)"
