#!/bin/bash
set -e

echo "Validating Node.js application is running..."

pm2 status express-app || {
  echo "ERROR: PM2 process not found.";
  exit 1;
}
