#!/bin/bash
echo "Setting up Node.js application with PM2 for automatic reboot..."

cd /home/ec2-user/express-app

echo "Current directory after cd: $(pwd)"
echo "Contents of current directory:"
ls -la

echo "Installing dependencies (consider moving to AfterInstall hook)..."
npm install

echo "Stopping and deleting existing PM2 processes for express-app..."
pm2 delete express-app 2>/dev/null || true

echo "Starting application 'express-app' with PM2..."

pm2 start app.js --name "express-app" --update-env 

echo "Saving PM2 process list..."
pm2 save


echo "Generating and enabling PM2 startup script for ec2-user..."
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user


echo "Enabling PM2 systemd service..."
sudo systemctl enable pm2-ec2-user.service 

echo "Application setup complete. It will now start automatically on system reboot."
echo "Current running processes:"
pm2 list
