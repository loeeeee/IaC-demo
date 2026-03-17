# -----------------------------------------------------------------------------
# VM MODULE
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.90.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  vm_id       = var.vm_id
  name        = var.name
  description = var.description
  node_name   = var.node_name

  clone {
    vm_id = var.clone_vm_id
  }

  cpu {
    cores = var.cpu_cores
    units = var.cpu_units
  }

  memory {
    dedicated = var.memory_dedicated
  }

  disk {
    datastore_id = var.disk_datastore_id
    size         = var.disk_size
    interface    = var.disk_interface
  }

  network_device {
    bridge      = var.network_bridge
    mac_address = var.mac_address
  }

  agent {
    enabled = var.agent_enabled
  }
}

