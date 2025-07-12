#!/bin/bash
echo "Starting application..."

# Navigate to application directory
cd /home/ec2-user/express-app/nodejs-express-on-aws-ec2

# Install dependencies if package.json exists
if [ -f "package.json" ]; then
  echo "Installing dependencies..."
  npm install
fi

# Start the application with PM2 in the background
# Assuming your main file is app.js or index.js - adjust if different
if [ -f "app.js" ]; then
  pm2 start app.js --name "express-app"
elif [ -f "index.js" ]; then
  pm2 start index.js --name "express-app"
elif [ -f "server.js" ]; then
  pm2 start server.js --name "express-app"
else
  echo "Could not find app.js, index.js, or server.js. Please specify the correct entry file."
  exit 1
fi

# Save PM2 process list so it restarts on reboot
pm2 save

# Set PM2 to start on system startup
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user

echo "Application started successfully in the background"
