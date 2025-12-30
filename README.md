# Self-Hosted Netbird Stack with Hardening & Monitoring

This repository contains a reference implementation for a self-hosted **Netbird Management Server** setup using Docker Compose. The configuration focuses on stability, resource efficiency, and compliance with standard infrastructure protection baselines (e.g., similar to BSI IT-Grundschutz modules for containerization).

It is designed for system administrators in public sector environments or SMEs who require a reliable overlay network without relying on external SaaS control planes.

## Features

- **Full Stack Deployment**: Includes Management, Dashboard, Signal, Relay, and Coturn (STUN/TURN).
- **Security Hardening**:
  - **CrowdSec Integration**: Log parsing for Caddy, Management, and Coturn to detect and block abusive IP addresses.
  - **Network Isolation**: Coturn runs with specific port bindings instead of `host` mode to maintain Docker network segregation.
  - **Reverse Proxy**: Caddy handles TLS termination automatically.
- **Identity Provider**: Integrated ZITADEL configuration for OIDC (OpenID Connect) authentication.
- **Resource Limits**: Log rotation and container restart policies configured for long-term maintenance-free operation.
- **IPv6 Support**: Configured for dual-stack environments.

## Architecture

The stack consists of the following components:

1. **Caddy**: Reverse Proxy for Dashboard and API endpoints.
2. **Netbird Core**: Management, Signal, and Relay services.
3. **Coturn**: VoIP media relay (TURN/STUN) with restricted port ranges.
4. **ZITADEL**: Self-hosted Identity Provider (can be replaced with other OIDC providers).
5. **PostgreSQL**: Database backend for ZITADEL.
6. **CrowdSec**: Intrusion Prevention System (IPS) reading logs from all containers.

## Prerequisites

- Ubuntu 24.04 LTS (recommended)
- Docker Engine & Docker Compose (v2.0+)
- Public IPv4 and IPv6 address
- DNS records pointing to your server IP (e.g., `netbird.example.com`)

## Quick Start

### 1. Clone the repository
git clone https://github.com/patrick-bloem/Netbird-self-hosted-stack.git
cd Netbird-self-hosted-stack

### 2. Initialize directories
Run the initialization script to create the necessary folder structure and log directories.
chmod +x init.sh
./init.sh


### 3. Configuration
Copy the example environment file and adjust the variables to your infrastructure.
cp .env.example .env
nano .env

*Note: Ensure to generate strong secrets for `ZITADEL_MASTERKEY` and `NETBIRD_SETUP_KEY`.*

### 4. Deployment
docker compose up -d

## Maintenance & Logs

Logs are configured with a `json-file` driver and rotation policies to prevent disk exhaustion.
To inspect CrowdSec metrics:
docker compose exec crowdsec cscli metrics

## Disclaimer

This configuration is provided "as is" for educational and administrative purposes. While it follows general hardening guidelines, please verify against your specific organizational compliance requirements before deploying in production.

---
**Author**: Patrick Bloem
**License**: MIT
