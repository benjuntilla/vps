terraform {
  required_providers {
    hostinger = {
      source  = "registry.terraform.io/hostinger/hostinger"
      version = "~> 0.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "hostinger" {
  api_token = var.hostinger_api_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "vps" {
  zone_id = var.cloudflare_zone_id
  name    = "vps"
  content = hostinger_vps.main.ipv4_address
  type    = "A"
  proxied = false
  ttl     = 300
}

import {
  to = hostinger_vps.main
  id = "1193834"
}

resource "hostinger_vps" "main" {
  plan           = var.vps_plan
  data_center_id = var.data_center_id
  template_id    = var.template_id
  hostname       = var.hostname
  ssh_key_ids    = [hostinger_vps_ssh_key.deploy.id]
}

resource "hostinger_vps_ssh_key" "deploy" {
  name = var.ssh_key_name
  key  = var.ssh_public_key
}


