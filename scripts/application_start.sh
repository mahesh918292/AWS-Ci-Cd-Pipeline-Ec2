#!/bin/bash

# Give permission for everything in the express-app directory
sudo chmod -R 777 /home/ec2-user/express-app

# Navigate into our working directory where we have all our github files
cd /home/ec2-user/express-app

# Add npm and node to path
export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion

# Install node modules
npm install

# Make sure port 3000 is free
sudo fuser -k 3000/tcp 2>/dev/null || true

# Start our node app in the background using PM2
if command -v pm2 &> /dev/null; then
  # If PM2 is installed, use it
  echo "Starting app with PM2..."
  pm2 delete app 2>/dev/null || true
  pm2 start app.js --name "app"
  pm2 save
else
  # Fall back to the original method if PM2 is not available
  echo "PM2 not found, starting app with node..."
  node app.js > app.out.log 2> app.err.log < /dev/null &
fi

echo "Application started"
