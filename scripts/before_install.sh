#!/bin/bash
echo "Executing BeforeInstall hook: Setting up Node.js, PM2, and deployment directory..."

# Update package lists
sudo yum update -y

# Install Node.js using NodeSource repository (more reliable for EC2)
echo "Installing Node.js via NodeSource repository..."
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs || { echo "ERROR: Node.js install failed."; exit 1; }

# Verify node and npm installation
node -v
npm -v

# Install PM2 globally
echo "Installing PM2 globally..."
sudo npm install -g pm2 || { echo "ERROR: PM2 global install failed."; exit 1; }

# Create our working directory if it doesn't exist and set proper permissions
# This directory MUST match the 'destination' in your appspec.yml.
DIR="/home/ec2-user/express-app"
if [ -d "$DIR" ]; then
  echo "${DIR} exists. Clearing its contents for new deployment..."
  sudo rm -rf ${DIR}/* # Clear old application files
else
  echo "Creating ${DIR} directory..."
  sudo mkdir -p ${DIR} # Create directory and any parent directories
fi

# Set ownership and permissions for the deployment directory
# This is crucial so ec2-user can write and execute files without sudo later
echo "Setting ownership and permissions for ${DIR}..."
sudo chown -R ec2-user:ec2-user ${DIR} || { echo "ERROR: Failed to set ownership."; exit 1; }
sudo chmod -R 755 ${DIR} || { echo "ERROR: Failed to set permissions."; exit 1; } # More secure than 777

echo "Node.js, PM2, and directory preparation completed."
exit 0
