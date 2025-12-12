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
  description = "Data center ID - run 'terraform plan' to see available_data_centers output. US options: Phoenix, Boston"
  type        = number
}

variable "template_id" {
  description = "OS template ID - run 'terraform plan' to see available_templates output. Look for Ubuntu 24.04"
  type        = number
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

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
