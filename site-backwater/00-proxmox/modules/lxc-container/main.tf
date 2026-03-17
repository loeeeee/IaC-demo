# -----------------------------------------------------------------------------
# LXC CONTAINER MODULE
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.90.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "container" {
  vm_id       = var.vm_id
  description = var.description
  node_name   = var.node_name
  started     = var.started

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  clone {
    vm_id = var.clone_vm_id
  }

  disk {
    datastore_id = var.disk_datastore_id
    size         = var.disk_size
  }

  cpu {
    cores = var.cpu_cores
    units = var.cpu_units
  }

  memory {
    dedicated = var.memory_dedicated
  }

  network_interface {
    name        = "eth0"
    bridge      = var.network_bridge
    mac_address = var.mac_address
  }

  features {
    nesting = true
  }

  unprivileged = var.unprivileged

  dynamic "mount_point" {
    for_each = var.mount_points
    content {
      volume    = mount_point.value.volume
      path      = mount_point.value.path
      replicate = mount_point.value.replicate
    }
  }

  dynamic "device_passthrough" {
    for_each = var.device_passthroughs
    content {
      path = device_passthrough.value.path
      gid  = device_passthrough.value.gid
    }
  }

  # Workaround for Proxmox provider bug where updating only 'started' 
  # attribute sends empty API payload causing "no options specified" error
  lifecycle {
    ignore_changes = [started]
  }
}

