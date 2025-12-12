variable "hostinger_api_token" {
  description = "Hostinger API token"
  type        = string
  sensitive   = true
}

variable "vps_plan" {
  description = "VPS plan identifier (e.g., hostingercom-vps-kvm2-usd-1m)"
  type        = string
  default     = "hostingercom-vps-kvm1-usd-1m"
}

variable "data_center_id" {
  description = "Data center ID - see available_data_centers output. US options: Phoenix, Boston"
  type        = number
  default     = 9
}

variable "template_id" {
  description = "OS template ID - see available_templates output for Ubuntu 24.04"
  type        = number
  default     = 1077
}

variable "hostname" {
  description = "VPS hostname"
  type        = string
}

variable "ssh_key_name" {
  description = "Name for the SSH key in Hostinger"
  type        = string
  default     = "deploy-key"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for benjuntilla.com"
  type        = string
}
