#!/bin/bash
set -e

echo "Setting up Node.js, PM2, and deployment directory..."

sudo yum update -y
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

node -v
npm -v

sudo npm install -g pm2

APP_DIR="/home/ec2-user/express-app"

if [ -d "$APP_DIR" ]; then
  rm -rf ${APP_DIR:?}/*
else
  mkdir -p "$APP_DIR"
fi

chown -R ec2-user:ec2-user "$APP_DIR"
chmod -R 755 "$APP_DIR"

echo "Node.js, PM2, and directory preparation completed."
