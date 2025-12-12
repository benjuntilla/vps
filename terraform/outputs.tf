output "vps_ip" {
  description = "VPS public IP address"
  value       = hostinger_vps.main.ipv4_address
}

output "vps_hostname" {
  description = "VPS hostname"
  value       = hostinger_vps.main.hostname
}

output "available_data_centers" {
  description = "Available data centers with IDs"
  value       = data.hostinger_vps_data_centers.all.data_centers
}

output "available_templates" {
  description = "Available OS templates with IDs"
  value       = data.hostinger_vps_templates.all.templates
}
