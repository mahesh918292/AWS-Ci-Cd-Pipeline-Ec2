#!/bin/bash
echo "Installing Node.js and PM2..."

# Update package lists
sudo yum update -y

# Install Node.js
echo "Installing Node.js..."
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

# Verify Node.js installation
echo "Node.js version:"
node -v
echo "NPM version:"
npm -v

# Install PM2 globally
echo "Installing PM2 globally..."
sudo npm install -g pm2

# Verify PM2 installation
echo "PM2 version:"
pm2 -v || echo "PM2 installation failed"

echo "Node.js and PM2 installation completed"
