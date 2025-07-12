#!/bin/bash
echo "Installing application dependencies..."

# Navigate to application directory
# Assuming 'nodejs-express-on-aws-ec2' is a subfolder within the deployed 'express-app'
cd /home/ec2-user/express-app/nodejs-express-on-aws-ec2 # <--- CORRECTED PATH

# Check if we're in the right directory
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Install dependencies
echo "Installing npm dependencies..."
# Ensure ec2-user has write permissions to the directory where npm install runs
npm install # <--- REMOVED sudo

# Check if node_modules was created
if [ -d "node_modules" ]; then
  echo "node_modules directory created successfully"
  echo "Contents of node_modules:"
  ls -la node_modules | head -n 10
else
  echo "WARNING: node_modules directory was not created! Check npm install errors above."
  exit 1 # Fail the script if node_modules isn't created
fi

echo "Application dependencies installation completed"