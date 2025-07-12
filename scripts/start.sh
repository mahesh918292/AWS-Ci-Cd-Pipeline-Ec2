#!/bin/bash
set -e

echo "Starting app with PM2..."

cd /home/ec2-user/express-app

pm2 delete express-app || true
pm2 start app.js --name "express-app" --update-env
pm2 save

if ! systemctl is-enabled pm2-ec2-user.service &>/dev/null; then
  env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user
  sudo systemctl enable pm2-ec2-user.service
else
  echo "PM2 systemd service already configured."
fi

pm2 list
