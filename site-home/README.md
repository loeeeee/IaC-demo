# Home Site Overview

The home site is a smaller Proxmox-based environment that provides core network infrastructure (DNS, DHCP, VPN, reverse proxy) and selected application services for the home network. This directory describes how the site is modeled in IaC across layers.

## Architecture Layers

- **Network**
  - Three main segments:
    - **LAN_Server**: trusted server network for core infrastructure services.
    - **LAN_Client**: client network for end-user devices.
    - **DMZ**: edge network for services exposed to or bridging to external networks.
  - PFsense (outside this repo) handles upstream routing, firewalling, DHCP ranges, and DDNS; Proxmox bridges (e.g., `vmbr0`, `vmbr1`, `vmbr5`) connect hosts into these subnets.

- **Compute**
  - A Proxmox VE node at home hosts:
    - **LXCs** for DNS, DHCP, Nix binary cache, reverse proxy, and tunnels.
    - **VMs** for site-to-site VPN and any heavier workloads that need full virtualization.
  - All Proxmox resources are defined declaratively via OpenTofu under `00-proxmox/`.

- **Storage**
  - Storage is simpler than backwater: Proxmox local storage and any attached pools are used to host LXC and VM disks.
  - Long-lived data and backups are generally handled at the application or remote-site level (e.g., backing into backwater storage).

- **Security**
  - PFsense enforces the main perimeter, including a WireGuard tunnel to other sites.
  - Internal segmentation between LAN_Server, LAN_Client, and DMZ limits which services are reachable from clients versus the internet.
  - NixOS firewall rules on home-site hosts complement PFsense by constraining service ports and administrative access.

- **Applications and Services**
  - **Infrastructure (core)**: DNS (Unbound + BIND), DHCP (Kea master/backup), and Nix binary cache / remote builder.
  - **Edge**: HAProxy and tunnels in the DMZ for exposing or bridging services.
  - **Selected applications**: small set of services needed at home (e.g., for development, tunneling, or local access), with heavier workloads typically running at backwater.

## Layers in This Site

- **Proxmox & OpenTofu (`00-proxmox/`)**
  - Defines Proxmox provider configuration, networks, and the home-site container/VM inventory.
  - Uses reusable modules (`lxc-container`, `vm`) to standardize shapes across services.

- **NixOS & services (`01-nix/`, if present)**
  - Provides operating system and service-level configuration for the home-site hosts created by `00-proxmox/`.
  - Follows the same design principles as backwater NixOS (clear roles, moderate modularity, and shared UID/GID strategy where needed).

Use this README as the conceptual entry point; follow `00-proxmox/` (and `01-nix/` if present) for layer-specific details.

