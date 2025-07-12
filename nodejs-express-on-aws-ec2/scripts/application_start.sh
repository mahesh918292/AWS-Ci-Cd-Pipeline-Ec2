#!/bin/bash
echo "Starting application..."

# Navigate to application directory
cd nodejs-express-on-aws-ec2

# Check if we're in the right directory
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Find the main file to run
MAIN_FILE=""
if [ -f "app.js" ]; then
  MAIN_FILE="app.js"
elif [ -f "index.js" ]; then
  MAIN_FILE="index.js"
elif [ -f "server.js" ]; then
  MAIN_FILE="server.js"
else
  echo "Could not find main file. Please specify the correct entry file."
  exit 1
fi

echo "Using $MAIN_FILE as the main application file"

# Stop any existing PM2 processes for this app
pm2 delete express-app 2>/dev/null || true

# Start the application with PM2
echo "Starting application with PM2..."
pm2 start $MAIN_FILE --name "express-app"

# Save the current process list
echo "Saving PM2 process list..."
pm2 save

# Generate and run startup script
echo "Setting up PM2 to start on system boot..."
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user

# Ensure PM2 service is enabled
echo "Enabling PM2 service..."
sudo systemctl enable pm2-ec2-user

echo "Application setup complete. It will now start automatically on system reboot."
echo "Current running processes:"
pm2 list
