#!/bin/bash
echo "Stopping any existing node servers..."

# Check if PM2 is installed and in PATH
if command -v pm2 &> /dev/null; then
  # Stop the specific application using PM2 by its name
  echo "Stopping PM2 process 'express-app'..."
  pm2 stop express-app 2>/dev/null || true # Stop by app name
  pm2 delete express-app 2>/dev/null || true # Delete from PM2 list by app name
else
  # Fallback to pkill if PM2 is not available (less ideal)
  echo "PM2 not found, attempting to kill all Node.js processes..."
  pkill -f node || true
fi

echo "Node server stop script completed"
exit 0