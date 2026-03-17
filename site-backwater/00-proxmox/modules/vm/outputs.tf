# -----------------------------------------------------------------------------
# VM MODULE OUTPUTS
# -----------------------------------------------------------------------------

output "vm_id" {
  description = "The VM ID of the virtual machine"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

