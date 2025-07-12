#!/bin/bash
echo "Executing BeforeInstall hook: Setting up Node.js, PM2, and deployment directory..."

# Update package lists
sudo yum update -y

# Download and install Node.js using NVM (as per your original script)
# NOTE: Using yum for Node.js is often more consistent for server environments.
# Example for yum: curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash - && sudo yum install -y nodejs
echo "Installing Node.js via NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
# Source NVM to make it available in the current shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node || { echo "ERROR: NVM Node.js install failed."; exit 1; }

# Install PM2 globally
echo "Installing PM2 globally..."
npm install -g pm2 || { echo "ERROR: PM2 global install failed."; exit 1; }

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