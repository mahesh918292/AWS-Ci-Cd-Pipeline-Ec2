#!/bin/bash
echo "Starting application..."

# Navigate to application directory
cd /home/ec2-user/express-app # <--- CORRECTED PATH

# Check if we're in the right directory
pm2 stop app.js
pm2 start app.js

pm2 startup systemd
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user
pm2 save

# Generate and run startup script (Ideally a one-time setup in User Data)
# If it must be here, add a check to run only if not already enabled.
echo "Setting up PM2 to start on system boot (if not already configured)..."
if ! systemctl is-enabled pm2-ec2-user.service &>/dev/null; then
  sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user
  # Ensure the generated service is enabled
  sudo systemctl enable pm2-ec2-user.service
else
  echo "PM2 startup service already configured."
fi

echo "Application setup complete. It will now start automatically on system reboot."
echo "Current running processes:"
pm2 list