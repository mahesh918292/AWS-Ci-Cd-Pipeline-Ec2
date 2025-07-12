#!/bin/bash
#Stopping existing node servers
echo "Stopping any existing node servers"
pkill node || true
echo "Node server stop script completed"
exit 0
