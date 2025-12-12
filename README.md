# VPS Infrastructure

Infrastructure as code for VPS deployment using Terraform, Ansible, and Docker Compose.

## Structure

```
├── terraform/    # VPS provisioning (Hostinger)
├── ansible/      # Server configuration
└── stacks/       # Docker Compose services
```

## Setup

### 1. Prerequisites

```bash
# Generate SSH key pair
ssh-keygen -t ed25519 -C "deploy"

# Get Hostinger API token from: https://hpanel.hostinger.com/profile/api

# Create GitHub PAT with repo scope for Spacelift webhook
```

### 2. Spacelift (Terraform)

1. Create account at [spacelift.io](https://spacelift.io)
2. Connect your GitHub repo
3. Create a stack with project root: `terraform/`
4. Add environment variables:
   - `TF_VAR_hostinger_api_token` (secret) - your Hostinger API token
   - `TF_VAR_hostname` - your VPS hostname (e.g., `vps.example.com`)
5. Add webhook notification for "Apply finished" events:
   - URL: `https://api.github.com/repos/YOUR_USER/vps/dispatches`
   - Header: `Authorization: Bearer <GITHUB_PAT>`
   - Payload:
     ```json
     {"event_type": "spacelift-apply", "client_payload": {"vps_ip": "{{ .Run.Stack.Outputs.vps_ip }}"}}
     ```

### 3. GitHub Actions (Ansible)

Add repository secret:
- `SSH_PRIVATE_KEY` - contents of your ed25519 private key

The workflow triggers automatically after Spacelift applies.

### 4. Configure Services

After deployment, SSH to server and configure:

```bash
ssh root@YOUR_VPS_IP
cd /opt/vps/stacks
cp .env.example .env

# Generate Traefik dashboard password
htpasswd -nb admin yourpassword | sed -e 's/\$/\$\$/g'

# Edit .env with your values
nano .env

# Restart stack
docker compose up -d
```

## Manual Trigger

```bash
gh workflow run deploy.yml -f vps_ip=YOUR_VPS_IP
```

## Networks

- **traefik-public**: External-facing services (routed through Traefik)
- **internal**: Database and internal services (no external access)

## Security

- SSH key authentication only (no passwords)
- UFW firewall: ports 22, 80, 443 only
- Traefik dashboard protected with basic auth
