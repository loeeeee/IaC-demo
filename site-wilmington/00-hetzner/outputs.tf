# -----------------------------------------------------------------------------
# OUTPUTS
#
# These outputs provide useful information about the synced Hetzner Cloud resources.
# -----------------------------------------------------------------------------

output "servers" {
  description = "List of all Hetzner Cloud servers"
  value       = data.hcloud_servers.all.servers
}

output "networks" {
  description = "List of all Hetzner Cloud networks"
  value       = data.hcloud_networks.all.networks
}

output "ssh_keys" {
  description = "List of all Hetzner Cloud SSH keys"
  value       = data.hcloud_ssh_keys.all.ssh_keys
}

output "volumes" {
  description = "List of all Hetzner Cloud volumes"
  value       = data.hcloud_volumes.all.volumes
}

output "load_balancers" {
  description = "List of all Hetzner Cloud load balancers"
  value       = data.hcloud_load_balancers.all.load_balancers
}

