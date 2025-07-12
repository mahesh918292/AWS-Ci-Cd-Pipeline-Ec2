#!/bin/bash
echo "Installing application dependencies..."

# Navigate to application directory
# Assuming 'nodejs-express-on-aws-ec2' is a subfolder within the deployed 'express-app'
cd /home/ec2-user/express-app # <--- CORRECTED PATH

# Check if we're in the right directory
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Install dependencies
echo "Installing npm dependencies..."
# Ensure ec2-user has write permissions to the directory where npm install runs
sudo npm install # <--- REMOVED sudo



