#!/bin/bash

# Infrastructure Setup Script
# Author: Patrick Bloem
# Description: Creates directory structure and placeholder files for Netbird stack

echo "Initializing Netbird Self-Hosted Stack directory structure..."

# Define directory structure
DIRS=(
    # Data directories
    "./data/caddy"
    "./data/management"
    "./data/postgres"
    "./data/zitadel/machinekey"
    "./data/crowdsec"
    
    # Configuration directories
    "./config/caddy"
    "./config/crowdsec/parsers"
    "./config/crowdsec/scenarios"
    
    # Log directories (mounted read-only by CrowdSec)
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

# Set permissions
# Caddy logs need to be readable by the CrowdSec container (usually UID 1000 or similar)
echo "Setting permissions for log directories..."
chmod 755 ./logs/caddy
chmod 755 ./logs/management
chmod 755 ./logs/coturn

# Create empty placeholder config files if they don't exist
# This prevents Docker from creating directories instead of files

if [ ! -f "./config/Caddyfile" ]; then
    touch ./config/Caddyfile
    echo "Created placeholder: ./config/Caddyfile"
fi

if [ ! -f "./config/turnserver.conf" ]; then
    touch ./config/turnserver.conf
    echo "Created placeholder: ./config/turnserver.conf"
fi

if [ ! -f "./config/crowdsec/acquis.yaml" ]; then
    touch ./config/crowdsec/acquis.yaml
    echo "Created placeholder: ./config/crowdsec/acquis.yaml"
fi

echo "--------------------------------------------------------"
echo "Initialization complete."
echo "Next steps:"
echo "1. Configure .env"
echo "2. Populate config/Caddyfile and config/turnserver.conf"
echo "3. Run 'docker compose up -d'"
echo "--------------------------------------------------------"
