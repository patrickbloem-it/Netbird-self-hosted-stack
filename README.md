# Self-Hosted Netbird Stack with Hardening & Monitoring

This repository contains a reference implementation for a self-hosted **Netbird Management Server** setup using Docker Compose. The configuration focuses on stability, resource efficiency, and compliance with standard infrastructure protection baselines (e.g., aligning with BSI IT-Grundschutz modules for containerization).

It is designed for system administrators in public sector environments or SMEs who require a reliable overlay network without relying on external SaaS control planes.

## Features

- **Full Stack Deployment**: Includes Management, Dashboard, Signal, Relay, and Coturn (STUN/TURN).
- **Advanced Threat Detection**:
  - **CrowdSec IPS**: Integrated Security Engine with **custom parsers** for Netbird Management and Coturn logs.
  - **Firewall Bouncer**: Direct integration with `nftables`/`iptables` to block malicious IPs at the network layer.
  - **Behavioral Analysis**: Custom scenarios to detect auth-brute-forcing and relay abuse.
- **Network Isolation**: Coturn runs with specific port bindings instead of `host` mode to maintain Docker network segregation.
- **Identity Provider**: Integrated ZITADEL configuration for OIDC (OpenID Connect) authentication.
- **Resource Limits**: Log rotation and container restart policies configured for long-term maintenance-free operation.
- **IPv6 Support**: Configured for dual-stack environments.

## Architecture

The stack consists of the following components:

1. **Caddy**: Reverse Proxy for Dashboard and API endpoints (TLS termination).
2. **Netbird Core**: Management, Signal, and Relay services.
3. **Coturn**: VoIP media relay (TURN/STUN) with restricted port ranges and network isolation.
4. **ZITADEL**: Self-hosted Identity Provider (can be replaced with other OIDC providers).
5. **PostgreSQL**: Database backend for ZITADEL.
6. **CrowdSec Stack**: 
   - **Security Engine**: Reads logs from all containers via `acquis.yaml`.
   - **Firewall Bouncer**: Applies decisions (bans) directly to the host firewall.

## Security Architecture

### CrowdSec Configuration
The stack bridges the gap between application logs and network defense:
1. **Log Acquisition**: Centralized acquisition via `acquis.yaml` mapping container logs to specific labels.
2. **Parsing**: Custom Grok patterns decode Netbird's specific log formats (Go-based logging) and Coturn's STUN/TURN allocation logs.
3. **Remediation**: A dedicated Firewall Bouncer container applies blocklists directly to the host's `INPUT` chain, protecting all Docker containers effectively.

### Compliance Notes
- **Log Rotation**: Strict limits (e.g., 50MB) per container to ensure audit trails without disk exhaustion.
- **Privacy**: Parsers are configured to anonymize sensitive user data before processing.

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
Run the initialization script to create the necessary folder structure, log directories, and placeholder configs.
chmod +x init.sh
./init.sh

### 3. Configuration
Copy the example environment file and adjust the variables to your infrastructure.
cp .env.example .env
nano .env

*Note: Ensure to generate strong secrets for `ZITADEL_MASTERKEY` and `NETBIRD_SETUP_KEY`.*

### 4. Deployment
Start the stack in detached mode.
docker compose up -d

### 5. Post-Deployment: CrowdSec Bouncer
Once the stack is running, generate an API key for the Firewall Bouncer and add it to your `.env` file.
Generate Key
docker compose exec crowdsec cscli bouncers add firewall-bouncer

Add to .env
nano .env # Set CROWDSEC_BOUNCER_KEY=...

Restart Bouncer
docker compose up -d --force-recreate cs-firewall-bouncer

## Maintenance & Logs

Logs are configured with a `json-file` driver and rotation policies to prevent disk exhaustion.

### Monitoring Security Status
To inspect CrowdSec metrics and active bans:
Show metrics
docker compose exec crowdsec cscli metrics

List active bans
docker compose exec crowdsec cscli decisions list

## Disclaimer

This configuration is provided "as is" for educational and administrative purposes. While it follows general hardening guidelines, please verify against your specific organizational compliance requirements before deploying in production.

---
**Author**: Patrick Bloem
**License**: MIT
