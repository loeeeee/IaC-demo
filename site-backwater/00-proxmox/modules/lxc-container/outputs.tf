# -----------------------------------------------------------------------------
# LXC CONTAINER MODULE OUTPUTS
# -----------------------------------------------------------------------------

output "vm_id" {
  description = "The VM ID of the container"
  value       = proxmox_virtual_environment_container.container.vm_id
}

