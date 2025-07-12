#!/bin/bash
echo "Installing application dependencies..."

# Navigate to application directory
cd nodejs-express-on-aws-ec2

# Check if we're in the right directory
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Install dependencies
echo "Installing npm dependencies..."
sudo npm install

# Check if node_modules was created
if [ -d "node_modules" ]; then
  echo "node_modules directory created successfully"
  echo "Contents of node_modules:"
  ls -la node_modules | head -n 10
else
  echo "WARNING: node_modules directory was not created!"
fi

echo "Application dependencies installation completed"
