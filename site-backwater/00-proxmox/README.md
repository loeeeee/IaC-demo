# Backwater Proxmox & OpenTofu Layer

This directory contains OpenTofu configuration for provisioning Proxmox VE resources at the backwater site: SDN networks, bridges, storage mappings, containers, and VMs. It defines the infrastructure that NixOS configurations in `01-nix/` attach to.

## Overview

- **Goal**: Declaratively model backwater’s Proxmox topology (network, compute, storage) so that core services and applications can be scheduled consistently.
- **Scope**: Proxmox SDN setup, network bridges, ZFS-backed storage pools, and the LXC/VM inventory grouped by role (infrastructure, platform, apps, gaming).

## Architecture Layers (in this directory)

- **Network**
  - Uses the `bpg/proxmox` provider (v0.90.0) with SDN support to define:
    - **SDN zone** `bwvlan` using `vmbr256` (OVS) as transport.
    - **VNets** for `vnetdmz` (DMZ), `vnetcli` (LAN_Client), and `vnetsrv` (LAN_Server, future).
  - Bridges:
    - `vmbr256` (SDN transport) carries VLANs 2, 3, 100.
    - `vmbr257` is a management network for Proxmox itself.
    - Legacy `vmbr0`/`vmbr1`/`vmbr100` are still present for some workloads but are being phased out.
  - Containers and VMs are attached to these VNets/bridges based on their role (DMZ services, LAN servers, LAN clients, game servers).

- **Compute**
  - OpenTofu modules define:
    - LXC containers for core infrastructure (DNS, DHCP, logging, observability, identity), platform services (Spark, Redis, PostgreSQL), and DMZ apps (reverse proxy, search, tunnels, mail relay, binary cache).
    - VMs for GPU workloads, Kubernetes/K3s, WireGuard gateway, WiFi gateway, and other specialized roles.
  - Workloads are described in grouped resources (by function) rather than ad-hoc per-host definitions to keep the Terraform layer focused on shapes and placement.

- **Storage**
  - Proxmox storage classes point at ZFS pools:
    - `Cesspool-*` for primary disks, databases, and container volumes.
    - `OlympicPool-*` for media and download-oriented workloads.
    - `DeadPool` for IaC and configuration state mounts.
  - Disk sizes, storage backends, and mount points are specified here; higher-level NixOS modules decide how to use the mounted paths.

- **Security and Constraints**
  - Proxmox-level firewall and SDN configuration provide coarse network segmentation; host-level rules are handled by NixOS.
  - Disk resizing for LXC root filesystems is intentionally avoided here due to provider limitations that trigger full replacements; servers are designed to be stateless with data on ZFS volumes instead.

## Relationship to Other Layers

- **Upwards (NixOS & services)**
  - Hosts defined here (LXCs and VMs) are configured by NixOS modules under `site-backwater/01-nix/`.
  - NixOS takes care of system services, application configuration, and fine-grained firewall rules per host.

- **Sideways (other sites)**
  - Together with PFsense, this layer provides the local endpoints for WireGuard tunnels to other sites (home, wilmington), which are further configured in NixOS.

## Where to Look for Details

- **SDN status and migration**: `SDN_STATUS.md` in this directory documents the current state of SDN vs legacy networks and any manual steps.
- **Exact host and service assignments**:
  - IPs, VMIDs, and hostnames are summarized in `site-backwater/01-nix/README.md` and individual NixOS modules.
  - Additional cross-site orchestration is driven by `host.yaml` at the repo root.

Use this README as a high-level map; the precise Proxmox resource definitions live in `main.tf`, modules under `modules/`, and associated `.tf` files in this directory.
