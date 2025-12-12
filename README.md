# VPS Infrastructure

Infrastructure as code for VPS deployment using Terraform, Ansible, and Docker Compose, orchestrated by Spacelift.

## Structure

```
├── terraform/           # VPS provisioning (Hostinger + Cloudflare DNS)
├── ansible/             # Server configuration
└── stacks/              # Docker Compose services
```

## Spacelift Setup

### 1. Prerequisites

```bash
# Generate SSH key pair
ssh-keygen -t ed25519 -C "deploy" -f ~/.ssh/vps_deploy

# Get API tokens:
# - Hostinger: https://hpanel.hostinger.com/profile/api
# - Cloudflare: https://dash.cloudflare.com/profile/api-tokens (Zone:DNS:Edit)
```

### 2. Shared Context (vps)

Create a context named `vps` with all shared environment variables:

| Variable | Type | Description |
|----------|------|-------------|
| `TF_VAR_hostinger_api_token` | Secret | Hostinger API token |
| `TF_VAR_cloudflare_api_token` | Secret | Cloudflare API token |
| `TF_VAR_cloudflare_zone_id` | Plain | Cloudflare Zone ID |
| `TF_VAR_domain` | Plain | Base domain (e.g., `example.com`) |
| `REPO_URL` | Plain | `https://github.com/YOUR_USER/vps.git` |
| `ACME_EMAIL` | Plain | Let's Encrypt email |
| `TRAEFIK_DASHBOARD_AUTH` | Secret | htpasswd hash (see below) |
| `POSTGRES_PASSWORD` | Secret | Database password |

**Mounted File (for SSH private key):**

| Filename | Description |
|----------|-------------|
| `ssh_key` | Contents of `~/.ssh/vps_deploy` (private key) |
| `ssh_key.pub` | Contents of `~/.ssh/vps_deploy.pub` (public key) |

> **Note**: SSH keys must be added as **mounted files** (not environment variables) to preserve newline formatting. Go to **Context → Mounted Files → Add** and paste the key contents.

### 3. Terraform Stack (vps-terraform)

- **Name**: `vps-terraform`
- **Project root**: `terraform`
- **Contexts**: Attach `vps`

### 4. Ansible Stack (vps-ansible)

- **Name**: `vps-ansible`
- **Project root**: `ansible`
- **Additional project globs**: `stacks/**/*` (to trigger on stacks changes)
- **Playbook**: `site.yml`
- **Runner image**: `public.ecr.aws/spacelift/runner-ansible:latest`
- **Contexts**: Attach `vps`
- **Dependency**: `vps-terraform` (provides `TF_VAR_vps_ip`)

### 5. Generate Traefik Dashboard Auth

```bash
# Generate password hash (no escaping needed for Spacelift context)
echo "admin:$(openssl passwd -apr1 yourpassword)"
```

Set the output value (e.g., `admin:$apr1$...`) as `TRAEFIK_DASHBOARD_AUTH` in the Spacelift `vps` context. The plaintext password will be used to log in.

## Deployment Flow

1. **Push to `terraform/`** → Triggers `vps-terraform` stack
   - Provisions VPS on Hostinger
   - Creates Cloudflare DNS records
   - Outputs `vps_ip`

2. **Push to `ansible/` or `stacks/`** → Triggers `vps-ansible` stack
   - Configures server (Docker, UFW firewall)
   - Creates Docker networks
   - Deploys containers from `stacks/docker-compose.yml`

3. **Terraform output triggers Ansible** via stack dependency
   - After VPS provisioning, Ansible automatically runs

## Services

All hostnames are derived from `TF_VAR_domain`:

| Service | URL | Description |
|---------|-----|-------------|
| Traefik Dashboard | `traefik.{domain}` | Reverse proxy admin (basic auth protected) |
| Whoami | `whoami.{domain}` | Test service |
| App | `app.{domain}` | Your application |

## Networks

- **traefik-public**: External-facing services (routed through Traefik)
- **internal**: Database and internal services (no external access)

## Security

- SSH key authentication only (no passwords)
- UFW firewall: ports 22, 80, 443 only
- Traefik dashboard protected with basic auth
- Secrets managed via Spacelift (never stored in repo)
- `acme.json` created with 0600 permissions, backed up daily

