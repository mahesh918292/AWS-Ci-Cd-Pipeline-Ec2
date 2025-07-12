#!/bin/bash
set -e

echo "Installing Node.js dependencies..."

cd /home/ec2-user/express-app
npm install --production

echo "Dependencies installed."
