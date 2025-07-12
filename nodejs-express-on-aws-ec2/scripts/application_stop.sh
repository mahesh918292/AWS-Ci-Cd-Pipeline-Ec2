#!/bin/bash
echo "Stopping any existing node servers"

# Check if PM2 is installed and in PATH
if command -v pm2 &> /dev/null; then
  # Stop the application using PM2
  echo "Stopping PM2 processes..."
  pm2 stop all || true
  pm2 delete all || true
else
  # Fallback to pkill if PM2 is not available
  echo "PM2 not found, using pkill..."
  pkill -f node || true
fi

echo "Node server stop script completed"
exit 0
