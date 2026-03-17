# Backwater NixOS & Services Architecture

This directory contains NixOS configurations for the backwater site. It defines how Proxmox-provisioned hosts are turned into concrete services (VPN gateways, DHCP/DNS, observability, identity, applications) and how they interact across networks and sites.

## Overview

- **Goal**: Provide a single, declarative layer for operating systems, services, and firewall rules on top of the Proxmox resources defined in `00-proxmox/`.
- **Scope**: NixOS roles for LAN_Server, LAN_Client, and DMZ nodes; cross-site VPN and WiFi gateways; observability; identity; and platform/application services.

## Network & Security

- **Site-to-site connectivity**
  - A dedicated WireGuard VM (`humboldt`) in the DMZ connects backwater with other sites (home, wilmington) using separate tunnels per site.
  - Each tunnel uses its own transit /30 network; routing and NAT are handled by nftables on the gateway VM.

- **WiFi gateway**
  - A WiFi gateway VM (`imperial`) bridges the Vanderbilt VuDevice WiFi network into a dedicated transit subnet, again using nftables for routing and NAT.
  - PCI passthrough is used for the wireless NIC; NixOS config manages iwd and firewall rules to keep traffic contained.

- **Intra-site segmentation**
  - NixOS firewall rules on each host reflect the intended role:
    - Infrastructure services expose only the minimal ports on LAN_Server and, where needed, to PFsense and HAProxy in the DMZ.
    - DMZ services expose HTTP(S) or application-specific ports but are fronted by HAProxy and protected by Authelia/LLDAP where appropriate.
  - DHCP and DNS services are configured to cooperate with PFsense and DDNS, so all sites share a consistent naming and addressing scheme.

## Compute & Services

- **Core infrastructure**
  - DHCP (Kea master/backup) and DNS (Unbound, BIND) live on LAN_Server, with configuration modularized so bulky `subnet4` definitions are kept separate (e.g., `LAN-server/dhcp-master/subnet4.nix`).
  - Observability stack (Prometheus, VictoriaLogs, Grafana, Gatus) monitors DMZ, LAN_Server, and remote sites through WireGuard tunnels.

- **Identity & access**
  - LLDAP provides directory services with carefully assigned UIDs/GIDs to align with host and container users.
  - Authelia sits in front of HAProxy-proxied services to enforce SSO and per-service policies, backed by PostgreSQL and LLDAP.
  - UID/GID assignments are cataloged centrally here to avoid collisions and permission issues on shared storage (e.g., virtiofs, ZFS mounts).

- **Applications & data workloads**
  - GPU and high-memory NixOS hosts run workloads like code-server, Immich, Jellyfin, Spark + HDFS, Redis, PostgreSQL, and Llama.cpp.
  - Application modules are intentionally moderate in modularity: repeated patterns are allowed to keep dependency graphs and mental overhead manageable.
  - Boot sequencing considerations (e.g., bring up DHCP/DNS before dependent apps) are encoded in systemd ordering and, where needed, documentation in this layer.

## Design Principles

- **Right amount of repetition**
  - Rather than over-modularizing every option into tiny Nix modules, commonly reused patterns are kept in a few well-chosen modules and repeated where appropriate.
  - This favors readability and straightforward reasoning over extreme DRY abstractions, aiming to scale to a few dozen hosts comfortably.

- **Separation of concerns**
  - Proxmox and OpenTofu own **where** a host runs and how it is attached to network/storage.
  - NixOS owns **what** runs on the host (services, users, firewall, boot behavior) and how it participates in cross-site flows (VPNs, routing, observability, identity).

## Layer Relationships

- **From Proxmox to NixOS**
  - Each LXC/VM defined in `site-backwater/00-proxmox/` has a corresponding NixOS configuration here (e.g., `LAN-server/*`, `DMZ/*`).
  - Shared storage and virtiofs mounts from ZFS pools are consumed by these NixOS roles to keep workloads stateless where possible.

- **From NixOS to higher layers**
  - Kubernetes add-ons (`LAN-server/k8s-server/k8s-addon/`) and application-specific directories (e.g., `DMZ/minecraft/`) build on top of the NixOS roles defined here.
  - Cross-site orchestration (deploy/update behavior and host targeting) is driven by the repo-root `host.yaml` and scripts, which reference NixOS configs in this directory.

Use this README as the entry point for understanding how backwater services are structured; for specific roles, follow the subdirectories (e.g., `LAN-server/`, `DMZ/`, `LAN-client/`) and their individual NixOS modules.

