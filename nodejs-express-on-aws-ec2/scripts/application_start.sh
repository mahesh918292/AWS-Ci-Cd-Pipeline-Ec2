#!/bin/bash
echo "Setting up Node.js application with PM2..."

# Navigate to application directory
cd /home/ec2-user/express-app/nodejs-express-on-aws-ec2

# Install dependencies
npm install

# Stop any existing PM2 processes for this app
pm2 delete express-app 2>/dev/null || true

# Start the application with PM2
pm2 start app.js --name "express-app"

# Save the current process list
pm2 save

# Generate and run startup script
pm2 startup | tail -n 1 > startup_command.txt
chmod +x startup_command.txt
sudo bash startup_command.txt

# Ensure PM2 service is enabled
sudo systemctl enable pm2-ec2-user

echo "Application setup complete. It will now start automatically on system reboot."
echo "Current running processes:"
pm2 list
