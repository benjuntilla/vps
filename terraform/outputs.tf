output "vps_ip" {
  description = "VPS public IP address"
  value       = hostinger_vps.main.ipv4_address
}

output "vps_hostname" {
  description = "VPS hostname"
  value       = hostinger_vps.main.hostname
}

