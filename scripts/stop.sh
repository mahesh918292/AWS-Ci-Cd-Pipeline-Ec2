#!/bin/bash
set -e

echo "Stopping any existing Node.js servers..."

if command -v pm2 &> /dev/null; then
  pm2 stop express-app || true
  pm2 delete express-app || true
else
  pkill -f node || true
fi

sudo fuser -k 3000/tcp || true
echo "Node server stop script completed."
