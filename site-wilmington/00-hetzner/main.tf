# -----------------------------------------------------------------------------
# REQUIRED PROVIDERS
#
# This block tells OpenTofu which providers we need to download and use.
# In this case, we need the Hetzner Cloud provider.
# -----------------------------------------------------------------------------
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.55"
    }
  }
}

provider "hcloud" {
  # Configuration options
  token = var.hetzner_api_token
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET ALL SERVERS
# -----------------------------------------------------------------------------
data "hcloud_servers" "all" {
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET ALL NETWORKS
# -----------------------------------------------------------------------------
data "hcloud_networks" "all" {
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET ALL SSH KEYS
# -----------------------------------------------------------------------------
data "hcloud_ssh_keys" "all" {
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET ALL VOLUMES
# -----------------------------------------------------------------------------
data "hcloud_volumes" "all" {
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET ALL LOAD BALANCERS
# -----------------------------------------------------------------------------
data "hcloud_load_balancers" "all" {
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET SPECIFIC NETWORK
# -----------------------------------------------------------------------------
data "hcloud_network" "willminton" {
  name = "willminton"
}

# -----------------------------------------------------------------------------
# DATA SOURCE TO GET SPECIFIC SSH KEYS
# -----------------------------------------------------------------------------
data "hcloud_ssh_key" "first" {
  name = "First"
}

data "hcloud_ssh_key" "second" {
  name = "Second"
}

# -----------------------------------------------------------------------------
# DEFINE THE TUFF SERVER RESOURCE
#
# This block defines the Tuff server in Hetzner Cloud.
# -----------------------------------------------------------------------------
resource "hcloud_server" "tuff" {
  name        = "Tuff"
  image       = "ubuntu-24.04"
  server_type = "cpx11"
  location    = "ash"
  datacenter  = "ash-dc1"

  ssh_keys = [
    data.hcloud_ssh_key.first.id,
    data.hcloud_ssh_key.second.id
  ]

  network {
    network_id = data.hcloud_network.willminton.id
    ip         = "172.23.0.2"
  }

  labels = {}

  # Ignore SSH keys changes since the server already exists with them configured
  # and they cannot be modified without recreating the server
  lifecycle {
    ignore_changes = [ssh_keys]
  }
}

