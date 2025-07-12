#!/bin/bash
echo "Stopping any existing node servers..."

# Only kill node processes owned by ec2-user
echo "Attempting to kill node processes owned by ec2-user..."
pkill -u ec2-user node || true

# Try to free port 3000 without failing if we don't have permission
echo "Attempting to free port 3000..."
fuser -k 3000/tcp 2>/dev/null || true

echo "Node server stop script completed"
# Always exit with success to prevent deployment failure
exit 0
