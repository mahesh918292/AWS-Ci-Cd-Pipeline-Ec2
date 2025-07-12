#!/bin/bash
echo "Executing ApplicationStart hook: Preparing and starting Node.js application..."

# Navigate into our working directory where we expect all our application files
# NOTE: This path MUST match the 'destination' in your appspec.yml.
# If your appspec.yml destination is '/', this path is incorrect.
cd /home/ec2-user/express-app || { echo "ERROR: Failed to change directory to /home/ec2-user/express-app. Check appspec.yml destination."; exit 1; }

# Check if we're in the right directory
echo "Current directory: $(pwd)"
echo "Directory contents:"
ls -la

# Add npm and node to path (for nvm-based installations)
# This assumes nvm was used in before_install.sh and is sourced.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"     # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # loads nvm bash_completion

# Install Node.js modules (moved here since AfterInstall.sh is not being used)
echo "Installing Node.js dependencies..."
npm install --production || { echo "ERROR: npm install failed."; exit 1; }

# Find the main application file
MAIN_FILE=""
if [ -f "app.js" ]; then
  MAIN_FILE="app.js"
elif [ -f "index.js" ]; then
  MAIN_FILE="index.js"
elif [ -f "server.js" ]; then
  MAIN_FILE="server.js"
else
  echo "ERROR: Could not find main application file (app.js, index.js, or server.js)."
  exit 1
fi

echo "Using $MAIN_FILE as the main application file."

# Make sure port 3000 is free (redundant with ApplicationStop, but harmless)
echo "Ensuring port 3000 is free..."
sudo fuser -k 3000/tcp 2>/dev/null || true

# Start our node app in the background using PM2
if command -v pm2 &> /dev/null; then
  echo "Starting app with PM2..."
  # Delete existing PM2 process by its specific name 'express-app'
  pm2 delete express-app 2>/dev/null || true
  # Start the application with PM2
  pm2 start "$MAIN_FILE" --name "express-app" --update-env || { echo "ERROR: PM2 failed to start application."; exit 1; }
  # Save the current PM2 process list (crucial for PM2 to restart on reboot)
  pm2 save || { echo "WARNING: PM2 save failed."; }

  # Configure PM2 for automatic startup on reboot (only if not already configured)
  echo "Setting up PM2 to start on system boot (if not already configured)..."
  if ! sudo systemctl is-enabled pm2-ec2-user.service &>/dev/null; then
    echo "PM2 systemd service not found/enabled. Generating and enabling it now."
    sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user || { echo "ERROR: PM2 startup generation failed."; exit 1; }
    sudo systemctl enable pm2-ec2-user.service || { echo "ERROR: PM2 service enable failed."; exit 1; }
  else
    echo "PM2 systemd service already configured for automatic startup."
  fi

  echo "Current running processes:"
  pm2 list
else
  echo "PM2 not found, falling back to starting app with node directly (not recommended for production)..."
  node "$MAIN_FILE" > app.out.log 2> app.err.log < /dev/null &
  echo "WARNING: Application started directly with node. It will NOT auto-restart on reboot."
fi

echo "Application started."
exit 0