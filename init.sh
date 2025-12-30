#!/bin/bash

# Infrastructure Setup Script
# Author: Patrick Bloem
# Description: Creates directory structure for Netbird stack

echo "Initializing Netbird Self-Hosted Stack directory structure..."

# Define base directories
DIRS=(
    "./data/caddy"
    "./data/management"
    "./data/postgres"
    "./data/zitadel/machinekey"
    "./data/crowdsec"
    "./config/crowdsec"
    "./logs/caddy"
    "./logs/management"
    "./logs/coturn"
    "./logs/zitadel"
)

# Create directories
for dir in "${DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created: $dir"
    else
        echo "Exists: $dir"
    fi
done

# Set permissions for Caddy logs (required for CrowdSec reading)
chmod 755 ./logs/caddy

# Create empty placeholder config files if they don't exist
if [ ! -f "./config/Caddyfile" ]; then
    touch ./config/Caddyfile
    echo "Created empty Caddyfile in ./config/"
fi

if [ ! -f "./config/turnserver.conf" ]; then
    touch ./config/turnserver.conf
    echo "Created empty turnserver.conf in ./config/"
fi

echo "Initialization complete. Please configure .env and config files before starting."
