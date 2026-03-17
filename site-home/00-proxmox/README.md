# Home Proxmox & OpenTofu Layer

This directory contains OpenTofu configuration for managing Proxmox VE resources at the home site. It defines how containers and VMs are shaped, attached to networks, and given storage so that NixOS can configure services on top.

## Overview

- **Goal**: Declaratively model the home site’s Proxmox infrastructure (network, compute, storage) in a compact, reusable way.
- **Scope**: Provider configuration, LXC/VM modules, and resource definitions for DNS, DHCP, Nix binary cache/remote builder, reverse proxy, and VPN.

## Architecture Layers (in this directory)

- **Network**
  - Uses Proxmox bridges to attach workloads to three core subnets:
    - **LAN_Server** (`vmbr0`, `172.21.0.0/24`) for core infrastructure.
    - **LAN_Client** (`vmbr1`, `172.21.3.0/24`) for end-user devices.
    - **DMZ** (`vmbr5`, `172.21.1.0/24`) for edge services (binary cache, HAProxy, tunnels, etc.).
  - Containers and VMs are placed on the appropriate bridge based on their role (LAN_Server infrastructure vs DMZ edge services).

- **Compute**
  - Reusable modules encapsulate common shapes:
    - `modules/lxc-container/` for LXCs with standardized CPU, memory, disk, and network attributes.
    - `modules/vm/` for VMs with a consistent template, disk layout, and NIC configuration.
  - Service groups are modeled in aggregate rather than tracking every node in this README:
    - **Infrastructure LXCs** on LAN_Server: DNS, DHCP, and related core services.
    - **DMZ LXCs/VMs**: Nix binary cache/remote builder, HAProxy reverse proxy, WireGuard VPN gateway.

- **Storage**
  - Containers and VMs use Proxmox datastores configured for the home site (e.g., local LVM or ZFS-backed storage).
  - Disk sizes and performance characteristics are captured in the OpenTofu resource attributes; higher-level data management (backups, replication) is handled outside this layer.

## Relationship to Other Layers

- **NixOS & services (`site-home/01-nix/`, if present)**
  - Hosts created here are configured by NixOS modules to run DNS, DHCP, binary cache, tunnels, and reverse proxy services.
  - NixOS takes care of service configuration, secrets management, and firewall rules.

- **Multi-site topology**
  - The WireGuard gateway VM at home participates in the site-to-site VPN mesh with backwater and other sites.
  - Cross-site deployment and update behavior is orchestrated from the repo root via `host.yaml` and scripts, which reference hosts defined here.

## Where to Look for Details

- **Provider and modules**: see `main.tf`, `variables.tf`, and the `modules/` subdirectory for exact resource definitions and inputs.
- **Service-level behavior**: refer to `site-home/README.md` for the site overview and to any NixOS configs (when present) for per-host service definitions.

Use this README as a high-level map of how the home Proxmox infrastructure is shaped; rely on the `.tf` files and modules for exact configuration.
