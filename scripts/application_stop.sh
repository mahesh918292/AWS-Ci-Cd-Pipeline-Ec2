#!/bin/bash
echo "Stopping any existing node servers..."

# Kill any node processes
echo "Killing any node processes..."
pkill node || true

# Kill any process using port 3000
echo "Killing any process using port 3000..."
sudo fuser -k 3000/tcp 2>/dev/null || true

echo "Node server stop script completed"
exit 0
