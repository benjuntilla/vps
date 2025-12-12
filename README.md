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
   - `TF_VAR_cloudflare_api_token` (secret) - your Cloudflare API token
   - `TF_VAR_cloudflare_zone_id` - your Cloudflare Zone ID
   - `TF_VAR_domain` - your base domain (e.g., `example.com`)
   - `TF_VAR_ssh_public_key` (secret) - contents of your ed25519 public key
5. Add webhook notification for "Apply finished" events:
   - URL: `https://api.github.com/repos/YOUR_USER/vps/dispatches`
   - Header: `Authorization: Bearer <GITHUB_PAT>`
   - Payload:
     ```json
     {"event_type": "spacelift-apply"}
     ```

### 3. GitHub Actions (Ansible)

Add repository secrets:
- `SSH_PRIVATE_KEY` - contents of your ed25519 private key

Add environment variables (used by Ansible):
- `DOMAIN` - your base domain (e.g., `example.com`)
- `ACME_EMAIL` - Let's Encrypt email
- `TRAEFIK_DASHBOARD_AUTH` - htpasswd hash (see below)
- `POSTGRES_PASSWORD` - database password (secret)

Hostnames are derived automatically from `DOMAIN`:
- `traefik.example.com` - Traefik dashboard
- `whoami.example.com` - Test service
- `app.example.com` - Your app

Generate Traefik dashboard password hash:
```bash
# Generate password hash with $$ escaping for docker-compose
echo "admin:$(openssl passwd -apr1 yourpassword)" | sed -e 's/\$/\$\$/g'
```

The workflow triggers automatically after Spacelift applies.

### 4. Manual Deployment

```bash
# Set required environment variables
export DOMAIN=example.com
export ACME_EMAIL=admin@example.com
export TRAEFIK_DASHBOARD_AUTH='admin:$$apr1$$...'
export POSTGRES_PASSWORD=secretpassword

# Run Ansible
cd ansible
ansible-playbook -i inventory.ini site.yml
```

Or trigger via GitHub Actions:
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
- Secrets passed as environment variables (never stored in repo)
