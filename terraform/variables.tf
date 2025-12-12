variable "hostinger_api_token" {
  description = "Hostinger API token"
  type        = string
  sensitive   = true
}

variable "vps_plan" {
  type        = string
  default     = "hostingercom-vps-kvm1-usd-1m"
}

variable "data_center_id" {
  description = "Think this is phoenix"
  type        = number
  default     = 9
}

variable "template_id" {
  description = "Ubuntu 24.04"
  type        = number
  default     = 1077
}

variable "ssh_key_name" {
  description = "Name for the SSH key in Hostinger"
  type        = string
  default     = "deploy-key"
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

variable "domain" {
  description = "Base domain for all services"
  type        = string
}
