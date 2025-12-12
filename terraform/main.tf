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

resource "hostinger_vps" "main" {
  plan            = var.vps_plan
  datacenter      = var.datacenter
  os_template     = var.os_template
  hostname        = var.hostname
  ssh_key_ids     = [hostinger_vps_ssh_key.deploy.id]
  enable_password = false
}

resource "hostinger_vps_ssh_key" "deploy" {
  name = var.ssh_key_name
  key  = file(var.ssh_public_key_path)
}
