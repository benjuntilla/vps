terraform {
  required_providers {
    hostinger = {
      source  = "registry.terraform.io/hostinger/hostinger"
      version = "~> 0.1"
    }
  }
}

provider "hostinger" {
  api_token = var.hostinger_api_token
}

data "hostinger_vps_data_centers" "all" {}
data "hostinger_vps_templates" "all" {}

resource "hostinger_vps" "main" {
  plan           = var.vps_plan
  data_center_id = var.data_center_id
  template_id    = var.template_id
  hostname       = var.hostname
  ssh_key_ids    = [hostinger_vps_ssh_key.deploy.id]
}

resource "hostinger_vps_ssh_key" "deploy" {
  name = var.ssh_key_name
  key  = file(var.ssh_public_key_path)
}

output "vps_ip" {
  value = hostinger_vps.main.ipv4_address
}

output "available_data_centers" {
  value = data.hostinger_vps_data_centers.all.data_centers
}

output "available_templates" {
  value = data.hostinger_vps_templates.all.templates
}
