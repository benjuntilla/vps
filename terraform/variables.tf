variable "hostinger_api_token" {
  description = "Hostinger API token"
  type        = string
  sensitive   = true
}

variable "vps_plan" {
  description = "VPS plan identifier"
  type        = string
  default     = "kvm-1"
}

variable "datacenter" {
  description = "Datacenter location"
  type        = string
  default     = "nl-ams"
}

variable "os_template" {
  description = "Operating system template"
  type        = string
  default     = "ubuntu-24.04-64"
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
