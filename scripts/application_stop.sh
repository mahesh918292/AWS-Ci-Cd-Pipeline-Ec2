#!/bin/bash
echo "Stopping any existing Node.js servers..."

# Check if PM2 is installed and in PATH
if command -v pm2 &> /dev/null; then
  # Stop and delete the specific application using PM2 by its name
  echo "Stopping PM2 process 'express-app'..."
  pm2 stop express-app 2>/dev/null || true # Stop by app name, ignore errors if not running
  pm2 delete express-app 2>/dev/null || true # Delete from PM2 list by app name, ignore errors
else
  # Fallback to pkill if PM2 is not available (less ideal, affects all Node.js processes)
  echo "PM2 not found, attempting to kill all Node.js processes..."
  pkill -f node || true
fi

# Kill any process still using port 3000 (as a robust fallback)
echo "Killing any process using port 3000..."
sudo fuser -k 3000/tcp 2>/dev/null || true

echo "Node server stop script completed."
exit 0