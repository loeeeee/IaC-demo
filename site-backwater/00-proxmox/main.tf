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
  # insecure = true
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
  unbound_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 100104)
  binary_cache_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 100105)
  code_server_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 130)
  immich_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 131)
  jellyfin_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 132)
  postgresql_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 133)
  lldap_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 115)
  authelia_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 116)
  kde_desktop_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 134)
  minecraft_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 100118)
  llama_cpp_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 139)
  redis_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 140)
  open_amplify_ai_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 100116)
  matrix_exists = contains([for container in data.proxmox_virtual_environment_containers.all.containers : container.vm_id], 100117)
  wireguard_exists = contains([for vm in data.proxmox_virtual_environment_vms.all.vms : vm.vm_id], 100112)
  imperial_exists = contains([for vm in data.proxmox_virtual_environment_vms.all.vms : vm.vm_id], 100113)
  gpu_server_exists = contains([for vm in data.proxmox_virtual_environment_vms.all.vms : vm.vm_id], 134)
}

# -----------------------------------------------------------------------------
# SDN CONFIGURATION
# -----------------------------------------------------------------------------

# SDN VLAN Zone on vmbr256
resource "proxmox_virtual_environment_sdn_zone_vlan" "backwater_zone" {
  id     = "bwvlan"
  bridge = "vmbr256"
  nodes  = [var.proxmox_node]
}

# DMZ VNet (VLAN 100)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_dmz" {
  id   = "dmz"
  zone = proxmox_virtual_environment_sdn_zone_vlan.backwater_zone.id
  tag  = 100
}

# DMZ Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_dmz" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_dmz.id
  cidr    = "172.22.100.0/24"
  gateway = "172.22.100.1"
}

# Client VNet (VLAN 3)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_client" {
  id   = "cli"
  zone = proxmox_virtual_environment_sdn_zone_vlan.backwater_zone.id
  tag  = 3
}

# Client Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_client" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_client.id
  cidr    = "172.22.1.0/24"
  gateway = "172.22.1.1"
}

# Server VNet (VLAN 2) - for future migration
resource "proxmox_virtual_environment_sdn_vnet" "vnet_server" {
  id   = "srv"
  zone = proxmox_virtual_environment_sdn_zone_vlan.backwater_zone.id
  tag  = 2
}

# Server Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_server" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_server.id
  cidr    = "172.22.0.0/24"
  gateway = "172.22.0.1"
}

# WAN 0 VNet (VLAN 256)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_wan_0" {
  id   = "wan0"
  zone = proxmox_virtual_environment_sdn_zone_vlan.backwater_zone.id
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
  cidr    = "192.168.100.0/30"
  gateway = "192.168.100.1"
}

# ToHome VNet (VLAN 6)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_to_home" {
  id   = "home"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 6
}

# ToHome Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_to_home" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_to_home.id
  cidr    = "192.168.100.4/30"
  gateway = "192.168.100.5"
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
  cidr    = "192.168.100.8/30"
  gateway = "192.168.100.9"
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
  cidr    = "192.168.100.12/30"
  gateway = "192.168.100.13"
}

# Proton VPN Memphis VNet (VLAN 18)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_proton_memphis" {
  id   = "proMemph"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 18
}

# Proton VPN Memphis Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_proton_memphis" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_proton_memphis.id
  cidr    = "192.168.100.16/30"
  gateway = "192.168.100.17"
}

# Proton VPN Hong Kong VNet (VLAN 22)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_proton_hong_kong" {
  id   = "proHongK"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 22
}

# Proton VPN Hong Kong Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_proton_hong_kong" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_proton_hong_kong.id
  cidr    = "192.168.100.20/30"
  gateway = "192.168.100.21"
}

# Proton VPN Berlin VNet (VLAN 26)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_proton_berlin" {
  id   = "proBerli"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 26
}

# Proton VPN Berlin Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_proton_berlin" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_proton_berlin.id
  cidr    = "192.168.100.24/30"
  gateway = "192.168.100.25"
}

# Proton VPN Tokyo VNet (VLAN 30)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_proton_tokyo" {
  id   = "proTokyo"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 30
}

# Proton VPN Tokyo Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_proton_tokyo" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_proton_tokyo.id
  cidr    = "192.168.100.28/30"
  gateway = "192.168.100.29"
}

# Proton VPN Seoul VNet (VLAN 34)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_proton_seoul" {
  id   = "proSeoul"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 34
}

# Proton VPN Seoul Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_proton_seoul" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_proton_seoul.id
  cidr    = "192.168.100.32/30"
  gateway = "192.168.100.33"
}

# Proton VPN Taipei VNet (VLAN 34)
resource "proxmox_virtual_environment_sdn_vnet" "vnet_proton_taipei" {
  id   = "proTaipe"
  zone = proxmox_virtual_environment_sdn_zone_vlan.transit_zone.id
  tag  = 38
}

# Proton VPN Seoul Subnet
resource "proxmox_virtual_environment_sdn_subnet" "subnet_proton_taipei" {
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet_proton_taipei.id
  cidr    = "192.168.100.36/30"
  gateway = "192.168.100.37"
}

# Apply SDN configuration
resource "proxmox_virtual_environment_sdn_applier" "apply_sdn" {
  depends_on = [
    # Backwater VNets
    proxmox_virtual_environment_sdn_zone_vlan.backwater_zone,
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
    proxmox_virtual_environment_sdn_vnet.vnet_to_home,
    proxmox_virtual_environment_sdn_vnet.vnet_vandy,
    proxmox_virtual_environment_sdn_vnet.vnet_remote_access,
    proxmox_virtual_environment_sdn_vnet.vnet_proton_memphis,
    proxmox_virtual_environment_sdn_vnet.vnet_proton_hong_kong,
    proxmox_virtual_environment_sdn_vnet.vnet_proton_berlin,
    proxmox_virtual_environment_sdn_vnet.vnet_proton_tokyo,
    proxmox_virtual_environment_sdn_vnet.vnet_proton_seoul,
    proxmox_virtual_environment_sdn_vnet.vnet_proton_taipei,
    proxmox_virtual_environment_sdn_subnet.subnet_to_wilmington,
    proxmox_virtual_environment_sdn_subnet.subnet_to_home,
    proxmox_virtual_environment_sdn_subnet.subnet_vandy,
    proxmox_virtual_environment_sdn_subnet.subnet_remote_access,
    proxmox_virtual_environment_sdn_subnet.subnet_proton_memphis,
    proxmox_virtual_environment_sdn_subnet.subnet_proton_hong_kong,
    proxmox_virtual_environment_sdn_subnet.subnet_proton_berlin,
    proxmox_virtual_environment_sdn_subnet.subnet_proton_tokyo,
    proxmox_virtual_environment_sdn_subnet.subnet_proton_seoul,
    proxmox_virtual_environment_sdn_subnet.subnet_proton_taipei,
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
# Kubernetes Server (Single Node)
# -----------------------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "k8s_server" {
  vm_id       = 106
  name        = "rigil"
  description = "# Kubernetes Server"
  node_name   = var.proxmox_node
  started     = false

  clone {
    vm_id = 9903
  }

  cpu {
    cores = 4
    units = 1024
    type  = "host"
    numa  = true
  }

  memory {
    dedicated = 16384
    floating  = 4096
  }

  disk {
    datastore_id = "Cesspool-VM"
    size         = 32
    interface    = "scsi0"
    iothread     = true
  }

  network_device {
    bridge      = "srv"
    mac_address = "REDACTED"
    queues      = 4
  }

  agent {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# VictoriaLogs container
# -----------------------------------------------------------------------------
module "victoria_logs" {
  source = "./modules/lxc-container"

  vm_id       = 107
  hostname    = "betelgeuse"
  description = "# VictoriaLogs"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/Cesspool/Database/VictoriaLogs"
      path      = "/var/lib/victorialogs"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# Kea DHCP Server container
# -----------------------------------------------------------------------------
module "dhcp" {
  source = "./modules/lxc-container"

  vm_id       = 108
  hostname    = "achernar"
  description = "# Kea DHCP Master"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 1024
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Unbound DNS container
# -----------------------------------------------------------------------------
module "unbound" {
  source = "./modules/lxc-container"

  vm_id       = 109
  hostname    = "hadar"
  description = "# Unbound DNS Master"
  node_name   = var.proxmox_node

  disk_size = 4
  cpu_cores = 2
  cpu_units = 1024
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Unbound DNS container
# -----------------------------------------------------------------------------
module "bind" {
  source = "./modules/lxc-container"

  vm_id       = 110
  hostname    = "altair"
  description = "# Bind DNS"
  node_name   = var.proxmox_node

  disk_size = 4
  cpu_cores = 2
  cpu_units = 1024
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Unbound DNS container
# -----------------------------------------------------------------------------
module "unbound-backup" {
  source = "./modules/lxc-container"

  vm_id       = 111
  hostname    = "acrux"
  description = "# Unbound DNS Backup"
  node_name   = var.proxmox_node

  disk_size = 4
  cpu_cores = 2
  cpu_units = 1024
  memory_dedicated = 2048
  disk_datastore_id = "Deadpool-LXC"

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Prometheus container
# -----------------------------------------------------------------------------
module "prometheus" {
  source = "./modules/lxc-container"

  vm_id       = 112
  hostname    = "spica"
  description = "# Prometheus"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/Cesspool/Database/Spica"
      path      = "/var/lib/prometheus"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# Grafana container
# -----------------------------------------------------------------------------
module "grafana" {
  source = "./modules/lxc-container"

  vm_id       = 113
  hostname    = "aldebaran"
  description = "# Grafana"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/OlympicPool/home/grafana"
      path      = "/var/lib/grafana"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# Unbound DNS container
# -----------------------------------------------------------------------------
module "dhcp-backup" {
  source = "./modules/lxc-container"

  vm_id       = 114
  hostname    = "lmc"
  description = "# DHCP Backup"
  node_name   = var.proxmox_node

  disk_size = 4
  cpu_cores = 2
  cpu_units = 1024
  memory_dedicated = 2048
  disk_datastore_id = "Deadpool-LXC"

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# LLDAP container
# -----------------------------------------------------------------------------
module "lldap" {
  source = "./modules/lxc-container"

  vm_id       = 115
  hostname    = "arcturus"
  description = "# LLDAP - Light LDAP Server"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 128
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Authelia container
# -----------------------------------------------------------------------------
module "authelia" {
  source = "./modules/lxc-container"

  vm_id       = 116
  hostname    = "antares"
  description = "# Authelia Authentication Server"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 128
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Code Server container
# -----------------------------------------------------------------------------
module "code_server" {
  source = "./modules/lxc-container"

  vm_id       = 130
  hostname    = "alnilam"
  description = "# Code Server"
  node_name   = var.proxmox_node

  disk_size = 64
  cpu_cores = 96
  cpu_units = 256
  memory_dedicated = 200704

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/Cesspool/home/loe"
      path      = "/home/loe"
      replicate = false
    },
    {
      volume    = "/Cesspool/home/loe/Projects"
      path      = "/home/loe/Projects"
      replicate = false
    },
    {
      volume    = "/Cesspool/home/loe/Archives"
      path      = "/home/loe/Archives"
      replicate = false
    },
    {
      volume    = "/Cesspool/home/loe/Archives/Documents"
      path      = "/home/loe/Archives/Documents"
      replicate = false
    },
    {
      volume    = "/Cesspool/home/loe/Archives/Mails"
      path      = "/home/loe/Archives/Mails"
      replicate = false
    },
    {
      volume    = "/Cesspool/home/loe/Archives/Projects"
      path      = "/home/loe/Archives/Projects"
      replicate = false
    },
    {
      volume    = "/Deadpool/IaC"
      path      = "/home/loe/Projects/IaC"
      replicate = false
    },
    {
      volume    = "/Cesspool/home/loe/DigitalMemory"
      path      = "/home/loe/DigitalMemory"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# Immich container
# -----------------------------------------------------------------------------
module "immich" {
  source = "./modules/lxc-container"

  vm_id       = 131
  hostname    = "alioth"
  description = "# Immich"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 16
  cpu_units = 32
  memory_dedicated = 8192

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/Cesspool/Database/Immich"
      path      = "/var/lib/immich"
      replicate = false
    },
    {
      volume    = "/Cesspool/home/loe/DigitalMemory"
      path      = "/mnt/loe-DigitalMemory"
      replicate = false
    },
    {
      volume    = "/Spool/home/loe/DigitalMemory"
      path      = "/mnt/loe-DigitalMemory_Spool"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# Jellyfin container
# -----------------------------------------------------------------------------
module "jellyfin" {
  source = "./modules/lxc-container"

  vm_id       = 132
  hostname    = "alnitak"
  description = "# Jellyfin Media Server"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/OlympicPool/Media"
      path      = "/mnt/Media"
      replicate = false
    },
    {
      volume    = "/OlympicPool/home/jellyfin"
      path      = "/var/lib/jellyfin"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# PostgreSQL container
# -----------------------------------------------------------------------------
module "postgresql" {
  source = "./modules/lxc-container"

  vm_id       = 133
  hostname    = "alkaid"
  description = "# PostgreSQL Database Server"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 96
  cpu_units = 512
  memory_dedicated = 32768

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/Cesspool/Database/Alkaid"
      path      = "/var/lib/postgresql/"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# GPU Server VM
# -----------------------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "gpu_server" {
  vm_id       = 134
  name        = "canopus"
  description = "# GPU Server"
  node_name   = var.proxmox_node

  clone {
    vm_id = 9903
  }

  cpu {
    cores = 80
    units = 512
    type  = "host"
    numa  = true
    sockets = 1
    affinity = "0-15,24-47,48-63,72-96"
  }

  memory {
    dedicated = 32768
    floating  = 16384
  }

  disk {
    datastore_id = "Cesspool-VM"
    size         = 768
    interface    = "scsi0"
    iothread     = true
  }

  # eth0: LAN_server network
  network_device {
    bridge      = "srv"
    mac_address = "REDACTED"
    queues      = 8
  }

  # GPU passthrough (AMD GPU)
  hostpci {
    device = "hostpci0"
    id     = "0000:c3:00"
    rombar = true
    xvga   = true
    pcie   = true
  }

  # VirtioFS shares
  virtiofs {
    mapping = "loe-Projects"
    cache   = "auto"
    expose_xattr = true
    expose_acl = true
  }

  virtiofs {
    mapping = "loe-DigitalMemory"
    cache   = "auto"
    expose_xattr = true
    expose_acl = true
  }

  virtiofs {
    mapping = "loe-Archives"
    cache   = "auto"
    expose_xattr = true
    expose_acl = true
  }

  agent {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# Apache Spark Master container
# -----------------------------------------------------------------------------
module "spark_master" {
  source = "./modules/lxc-container"

  vm_id       = 136
  hostname    = "mizar"
  description = "# Apache Spark Master"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 4
  cpu_units = 32
  memory_dedicated = 8192

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Apache Spark Worker 1 container
# -----------------------------------------------------------------------------
module "spark_worker1" {
  source = "./modules/lxc-container"

  vm_id       = 137
  hostname    = "polaris"
  description = "# Apache Spark Worker 1"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 4
  cpu_units = 32
  memory_dedicated = 8192

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Apache Spark Worker 2 container
# -----------------------------------------------------------------------------
module "spark_worker2" {
  source = "./modules/lxc-container"

  vm_id       = 138
  hostname    = "centauri"
  description = "# Apache Spark Worker 2"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 4
  cpu_units = 32
  memory_dedicated = 8192

  network_bridge = "srv"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Redis container
# -----------------------------------------------------------------------------
module "redis" {
  source = "./modules/lxc-container"

  vm_id       = 140
  hostname    = "vega"
  description = "# Redis Database Server"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 4
  cpu_units = 128
  memory_dedicated = 4096

  network_bridge = "srv"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/Cesspool/Database/Redis"
      path      = "/var/lib/redis"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# Gatus container
# -----------------------------------------------------------------------------
module "gatus" {
  source = "./modules/lxc-container"

  vm_id       = 117
  hostname    = "pollux"
  description = "# Gatus Health Monitoring"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "srv"
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
# Proton Bridge VM
# -----------------------------------------------------------------------------
# module "proton_wg_bridge" {
#   source = "./modules/vm"

#   vm_id       = 100101
#   name        = "proton_wg_bridge"
#   description = "# Proton Wireguard Bridge"
#   node_name   = var.proxmox_node

#   cpu_cores = 4
#   cpu_units = 1024
#   memory_dedicated = 16384

#   disk_size = 32
#   disk_datastore_id = "Cesspool-VM"
#   disk_interface = "scsi0"

#   network_bridge = "srv"
#   mac_address    = "REDACTED"

#   depends_on = [module.k3s_server]
# }

# -----------------------------------------------------------------------------
# Binary Cache container
# -----------------------------------------------------------------------------
module "binary_cache" {
  source = "./modules/lxc-container"

  vm_id       = 100105
  hostname    = "calaveras"
  description = "# Nix Binary Cache (Harmonia) / Remote Builder"
  node_name   = var.proxmox_node

  disk_size = 128
  cpu_cores = 96
  cpu_units = 32
  memory_dedicated = 65536

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# qBittorent container
# -----------------------------------------------------------------------------
module "qbittorent" {
  source = "./modules/lxc-container"

  vm_id       = 100106
  hostname    = "colusa"
  description = "# qBittorent"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 16
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/OlympicPool/Media"
      path      = "/mnt/Media"
      replicate = false
    },
    {
      volume    = "/OlympicPool/home/qbittorrent"
      path      = "/var/lib/qbittorrent"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# Dufs container
# -----------------------------------------------------------------------------
module "dufs" {
  source = "./modules/lxc-container"

  vm_id       = 100107
  hostname    = "contracosta"
  description = "# Dufs"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"

  mount_points = [
    {
      volume    = "/Cesspool/home/loe/Share"
      path      = "/mnt/Share-loe"
      replicate = false
    }
  ]
}

# -----------------------------------------------------------------------------
# WS Tunnel Proxy container
# -----------------------------------------------------------------------------
module "ws_tunnel" {
  source = "./modules/lxc-container"

  vm_id       = 100108
  hostname    = "delnorte"
  description = "# WS Tunnel Proxy"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 128
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# LibreSpeed Speedtest container
# -----------------------------------------------------------------------------
module "speedtest" {
  source = "./modules/lxc-container"

  vm_id       = 100109
  hostname    = "eldorado"
  description = "# LibreSpeed Speedtest Server"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# HAProxy Reverse Proxy container
# -----------------------------------------------------------------------------
module "haproxy" {
  source = "./modules/lxc-container"

  vm_id       = 100110
  hostname    = "fresno"
  description = "# HAProxy Reverse Proxy with ACME SSL"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 128
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Mailserver container
# -----------------------------------------------------------------------------
module "mailserver" {
  source = "./modules/lxc-container"

  vm_id       = 100111
  hostname    = "sacramento"
  description = "# NixOS Mailserver"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"

  # Demo server without persistent storage
  # mount_points = [
  #   {
  #     volume    = "/Cesspool/home/loe/Archives/Mails"
  #     path      = "/var/vmail"
  #     replicate = false
  #   }
  # ]
}

# -----------------------------------------------------------------------------
# WireGuard Site-to-Site VPN Gateway VM
# -----------------------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "wireguard" {
  vm_id       = 100112
  name        = "humboldt"
  description = "# WireGuard VPNs"
  node_name   = var.proxmox_node

  clone {
    vm_id = 9903
  }

  cpu {
    cores = 12
    units = 128
    type  = "host"
    numa  = true
  }

  memory {
    dedicated = 8192
    shared    = 4096
  }

  disk {
    datastore_id = "Cesspool-VM"
    size         = 32
    interface    = "scsi0"
    iothread     = true
  }

  # eth0: DMZ network (default gateway)
  network_device {
    bridge      = "dmz"
    mac_address = "REDACTED"
    queues      = 12
  }

  # eth1: Transit network trunk (VLANs 2, 6, 14 configured inside VM)
  network_device {
    bridge      = "vmbr258"
    mac_address = "REDACTED"
    queues      = 12
  }

  agent {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# Vanderbilt WiFi Gateway VM
# -----------------------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "imperial" {
  vm_id       = 100113
  name        = "imperial"
  description = "# WiFi Gateway"
  node_name   = var.proxmox_node
  on_boot     = false
  started     = false

  clone {
    vm_id = 9903
  }

  cpu {
    cores = 2
    units = 32
    type  = "host"
    affinity = "8-11,56-59"
  }

  memory {
    dedicated = 2048
    shared    = 2048
  }

  disk {
    datastore_id = "Cesspool-VM"
    size         = 32
    interface    = "scsi0"
    iothread     = true
  }

  # eth0: DMZ network (default gateway)
  network_device {
    bridge      = "dmz"
    mac_address = "REDACTED"
    queues      = 2
  }

  # eth1: vandy transit network
  network_device {
    bridge      = "vandy"
    mac_address = "REDACTED"
    queues      = 2
  }

  # WiFi card passthrough (raw PCI device)
  hostpci {
    device = "hostpci0"
    id     = "0000:81:00.0"
    rombar = true
  }

  agent {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# SearXNG container
# -----------------------------------------------------------------------------
module "searxng" {
  source = "./modules/lxc-container"

  vm_id       = 100114
  hostname    = "inyo"
  description = "# SearXNG - Privacy-respecting Meta Search Engine"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 32
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}


# -----------------------------------------------------------------------------
# Claw container
# -----------------------------------------------------------------------------
module "claw" {
  source = "./modules/lxc-container"

  vm_id       = 100115
  hostname    = "capella"
  description = "# Claw"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Open Amplify AI container
# -----------------------------------------------------------------------------
module "open_amplify_ai" {
  source = "./modules/lxc-container"

  vm_id       = 100116
  hostname    = "kings"
  description = "# Open Amplify AI"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 2
  cpu_units = 32
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Matrix (Tuwunel) container
# -----------------------------------------------------------------------------
module "matrix" {
  source = "./modules/lxc-container"

  vm_id       = 100117
  hostname    = "lake"
  description = "# Matrix Homeserver (Tuwunel)"
  node_name   = var.proxmox_node

  disk_size        = 32
  cpu_cores        = 2
  cpu_units        = 32
  memory_dedicated = 2048

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# Minecraft container
# -----------------------------------------------------------------------------
module "minecraft" {
  source = "./modules/lxc-container"

  vm_id       = 100118
  hostname    = "lassen"
  description = "# Minecraft Server"
  node_name   = var.proxmox_node

  disk_size = 32
  cpu_cores = 32
  cpu_units = 32
  memory_dedicated = 49152

  network_bridge = "dmz"
  mac_address    = "REDACTED"
}

# -----------------------------------------------------------------------------
# ░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓████████▓▒░▒▓███████▓▒░▒▓████████▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░
# ░▒▓█▓▒░      ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░▒▓██████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░
# ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░
# ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓████████▓▒░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░
# -----------------------------------------------------------------------------
