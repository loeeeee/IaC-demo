# -----------------------------------------------------------------------------
# REQUIRED PROVIDERS
# -----------------------------------------------------------------------------
terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.90.0"
    }
  }
}

provider "proxmox" {
  # Configuration options
  endpoint = var.proxmox_api_url
  # api_token = var.proxmox_api_token
  username = "root@pam"
  password = var.proxmox_root_password
  insecure = true
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET ALL CONTAINERS ON THE NODE
# -----------------------------------------------------------------------------
data "proxmox_virtual_environment_containers" "all" {
  node_name = var.proxmox_node
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET ALL VMS ON THE NODE
# -----------------------------------------------------------------------------
data "proxmox_virtual_environment_vms" "all" {
  node_name = var.proxmox_node
}

# -----------------------------------------------------------------------------
# LOCALS TO CHECK CONTAINER EXISTENCE
# -----------------------------------------------------------------------------
locals {
  binary_cache_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 1101)
  ws_tunnel_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 1102)
  unbound_master_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 126)
  unbound_backup_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 127)
  bind_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 128)
  dhcp_master_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 129)
  dhcp_backup_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 130)
  wireguard_exists = contains([for vm in data.proxmox_virtual_environment_vms.all.vms : vm.vm_id], 1104)
}

# -----------------------------------------------------------------------------
# SDN CONFIGURATION
# -----------------------------------------------------------------------------

# SDN VLAN Zone on vmbr256
resource "proxmox_virtual_environment_sdn_zone_vlan" "home_zone" {
  id     = "homevlan"
  bridge = "vmbr257"
  nodes  = [var.proxmox_node]
}

# Server VNet (VLAN 2) - for future migration
resource "proxmox_virtual_environment_sdn_vnet" "vnet_server" {
  id   = "srv"
  zone = proxmox_virtual_environment_sdn_zone_vlan.home_zone.id
  tag  = 2
}

# Server Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_server" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_server.id
  cidr    = "172.21.0.0/24"
  gateway = "172.21.0.1"
}

# DMZ VNet (VLAN 2)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_dmz" {
  id   = "dmz"
  zone = proxmox_virtual_environment_sdn_zone_vlan.home_zone.id
  tag  = 3
}

# DMZ Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_dmz" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_dmz.id
  cidr    = "172.21.1.0/24"
  gateway = "172.21.1.1"
}

# Client VNet (VLAN 3)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_client" {
  id   = "cli"
  zone = proxmox_virtual_environment_sdn_zone_vlan.home_zone.id
  tag  = 5
}

# Client Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_client" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_client.id
  cidr    = "172.21.3.0/24"
  gateway = "172.21.3.1"
}

# WAN 0 VNet (VLAN 256)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_wan_0" {
  id   = "wan0"
  zone = proxmox_virtual_environment_sdn_zone_vlan.home_zone.id
  tag  = 256
}

# SDN VLAN Zone on vmbr258
resource "proxmox_virtual_environment_sdn_zone_vlan" "transit_zone" {
  id     = "transit"
  bridge = "vmbr258"
  nodes  = [var.proxmox_node]
}

# ToWilmington VNet (VLAN 2)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_to_wilmington" {
  id   = "wilmingt"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 2
}

# ToWilmington Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_to_wilmington" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_to_wilmington.id
  cidr    = "192.168.21.0/30"
  gateway = "192.168.21.1"
}

# ToBackwater VNet (VLAN 6)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_to_backwater" {
  id   = "bkwate"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 6
}

# ToBackwater Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_to_backwater" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_to_backwater.id
  cidr    = "192.168.21.4/30"
  gateway = "192.168.21.5"
}

# Vanderbilt Wifi VNet (VLAN 10)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_vandy" {
  id   = "vandy"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 10
}

# Vanderbilt Wifi Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_vandy" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_vandy.id
  cidr    = "192.168.21.8/30"
  gateway = "192.168.21.9"
}

# Remote Access VNet (VLAN 14)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_remote_access" {
  id   = "remote"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 14
}

# Remote Access Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_remote_access" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_remote_access.id
  cidr    = "192.168.21.12/30"
  gateway = "192.168.21.13"
}

# Apply SDN configuration
resource "proxmox_virtual_environment_sdn_applier" "apply_sdn" {
  depends_on = [
    # Home VNets
    proxmox_virtual_environment_sdn_zone_vlan.home_zone,
    proxmox_virtual_environment_sdn_vnet.vnet_dmz,
    proxmox_virtual_environment_sdn_vnet.vnet_client,
    proxmox_virtual_environment_sdn_vnet.vnet_server,
    proxmox_virtual_environment_sdn_vnet.vnet_wan_0,
    proxmox_virtual_environment_sdn_subnet.subnet_dmz,
    proxmox_virtual_environment_sdn_subnet.subnet_client,
    proxmox_virtual_environment_sdn_subnet.subnet_server,
    # Transit VNets
    proxmox_virtual_environment_sdn_zone_vlan.transit_zone,
    proxmox_virtual_environment_sdn_vnet.vnet_to_wilmington,
    proxmox_virtual_environment_sdn_vnet.vnet_to_backwater,
    proxmox_virtual_environment_sdn_vnet.vnet_vandy,
    proxmox_virtual_environment_sdn_vnet.vnet_remote_access,
    proxmox_virtual_environment_sdn_subnet.subnet_to_wilmington,
    proxmox_virtual_environment_sdn_subnet.subnet_to_backwater,
    proxmox_virtual_environment_sdn_subnet.subnet_vandy,
    proxmox_virtual_environment_sdn_subnet.subnet_remote_access,
  ]
}

# -----------------------------------------------------------------------------
# ░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓███████▓▒░ ░▒▓███████▓▒░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓███████▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░
# ░▒▓█▓▒░      ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░ ░▒▓█▓▒▒▓█▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░
# ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░  ░▒▓██▓▒░  ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# LXC CONTAINERS
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Unbound DNS Master container
# -----------------------------------------------------------------------------
module "unbound" {
  source = "./modules/lxc-container"

  vm_id       = 126
  hostname    = "setagaya"
  description = "# Unbound DNS Master"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 128
  memory_dedicated = 2048

  network_bridge = "vmbr0"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Unbound DNS Backup container
# -----------------------------------------------------------------------------
module "unbound_backup" {
  source = "./modules/lxc-container"

  vm_id       = 127
  hostname    = "nerima"
  description = "# Unbound DNS Backup"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 128
  memory_dedicated = 2048

  network_bridge = "vmbr0"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Bind DNS container
# -----------------------------------------------------------------------------
module "bind" {
  source = "./modules/lxc-container"

  vm_id       = 128
  hostname    = "ota"
  description = "# Bind DNS"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 1024
  memory_dedicated = 2048

  network_bridge = "vmbr0"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Kea DHCP Master container
# -----------------------------------------------------------------------------
module "dhcp" {
  source = "./modules/lxc-container"

  vm_id       = 129
  hostname    = "edogawa"
  description = "# Kea DHCP Master"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 128
  memory_dedicated = 2048

  network_bridge = "vmbr0"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Kea DHCP Backup container
# -----------------------------------------------------------------------------
module "dhcp_backup" {
  source = "./modules/lxc-container"

  vm_id       = 130
  hostname    = "adachi"
  description = "# Kea DHCP Backup"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 128
  memory_dedicated = 2048

  network_bridge = "vmbr0"
  mac_address    = "REDACTED"
}


# -----------------------------------------------------------------------------
# ░▒▓███████▓▒░░▒▓██████████████▓▒░░▒▓████████▓▒░
# ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░
# ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░    ░▒▓██▓▒░
# ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░  ░▒▓██▓▒░
# ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██▓▒░
# ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
# ░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Binary Cache / Remote Builder container
# -----------------------------------------------------------------------------
module "binary_cache" {
  source = "./modules/lxc-container"

  vm_id       = 1101
  hostname    = "sapporo"
  description = "# Nix Binary Cache (Harmonia) / Remote Builder"
  node_name   = var.proxmox_node

  disk_size        = 64
  cpu_cores        = 14
  memory_dedicated = 28672

  network_bridge = "vmbr5"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# WS Tunnel Server container
# -----------------------------------------------------------------------------
module "ws_tunnel" {
  source = "./modules/lxc-container"

  vm_id       = 1102
  hostname    = "asahikawa"
  description = "# WS Tunnel Server"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 128
  memory_dedicated = 2048

  network_bridge = "vmbr5"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# HAProxy Reverse Proxy container
# -----------------------------------------------------------------------------
module "haproxy" {
  source = "./modules/lxc-container"

  vm_id       = 1103
  hostname    = "hakodate"
  description = "# HAProxy Reverse Proxy"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 128
  memory_dedicated = 2048

  network_bridge = "vmbr5"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# WireGuard Site-to-Site VPN Gateway VM
# -----------------------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "wireguard" {
  vm_id       = 1104
  name        = "tomakomai"
  description = "# WireGuard VPNs"
  node_name   = var.proxmox_node

  clone {
    vm_id = 25601
  }

  cpu {
    cores = 2
    units = 128
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "VMs"
    size         = 32
    interface    = "scsi0"
  }

  # eth0: DMZ network (default gateway)
  network_device {
    bridge      = "vmbr5"
    mac_address = "REDACTED"
  }

  # eth1: Transit network trunk
  network_device {
    bridge      = "vmbr258"
    mac_address = "REDACTED"
  }

  agent {
    enabled = true
  }
}
