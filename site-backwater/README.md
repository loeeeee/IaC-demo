# Backwater Site Overview

Backwater is a Proxmox-based site that hosts most core homelab infrastructure (DNS, DHCP, VPN, observability) along with application and gaming workloads. This directory describes how the site is modeled in IaC across layers rather than documenting every individual host.

```mermaid
flowchart TD
  repo[IaC_Repo] --> backwater[Backwater_Site]
  repo --> home[Home_Site]

  subgraph backwater_layers[Backwater_Site_Layers]
    bw_proxmox[Backwater_Proxmox_OpenTofu]
    bw_nix[Backwater_NixOS_Configs]
    bw_apps[Backwater_Apps_(k8s_addons,_minecraft)]
  end

  subgraph home_layers[Home_Site_Layers]
    home_proxmox[Home_Proxmox_OpenTofu]
    home_nix[Home_NixOS_Configs]
  end

  backwater --> backwater_layers
  home --> home_layers

  bw_proxmox --> bw_nix --> bw_apps
  home_proxmox --> home_nix
```

## Architecture Layers

- **Network**
  - Proxmox SDN provides VLAN-based segmentation for **DMZ**, **LAN_Server**, and **LAN_Client** networks, using an OVS transport bridge to carry tagged traffic.
  - Legacy bridges (`vmbr0`, `vmbr1`, `vmbr100`) are being phased out in favor of SDN VNets; SDN migration status and manual steps are tracked in `00-proxmox/SDN_STATUS.md`.
  - PFsense provides upstream routing, firewalling, DHCP, DNS (backup), WireGuard, and DDNS for the site; Proxmox and NixOS hosts attach to these segments via SDN or legacy bridges.

- **Compute**
  - A Proxmox VE node at backwater runs both **LXC containers** and **VMs** defined declaratively via OpenTofu under `00-proxmox/`.
  - Workloads are grouped by role:
    - **Infrastructure:** DNS (Unbound, BIND), DHCP (Kea), binary cache, reverse proxy, mail relay.
    - **Platform & observability:** Prometheus, VictoriaLogs, Grafana, Gatus, Spark + HDFS, Redis, PostgreSQL.
    - **Identity & access:** LLDAP, Authelia.
    - **Applications & data:** Immich, Jellyfin, qBittorrent, code-server, Llama.cpp, Matrix homeserver, Minecraft, and others.
  - NixOS is the standard guest OS; stateful data is kept on host pools via bind mounts so guests remain largely stateless.

- **Storage**
  - ZFS pools provide distinct storage tiers consumed by Proxmox:
    - **Cesspool**: primary, high-capacity, high-performance pool for Proxmox disks, databases, and general data.
    - **OlympicPool**: large, non-redundant pool for media, downloads, and non-critical data.
    - **DeadPool**: mirrored pool for mission-critical configuration and IaC data.
  - Proxmox storage mappings and how disks/subvols are attached to guests are defined in `00-proxmox/` (ZFS dataset inventories are left to ZFS tooling, not this README).

- **Security**
  - PFsense enforces the main **north–south** boundary (internet ↔ backwater), including WireGuard site-to-site VPNs to other sites.
  - Internal segmentation between **DMZ**, **LAN_Server**, and **LAN_Client** constrains exposure of public-facing services versus infrastructure and user devices.
  - Service-level security is implemented by:
    - NixOS firewall rules on each host.
    - HAProxy in the DMZ for TLS termination, ACME (Let’s Encrypt via DNS-01), and HTTP(S) routing.
    - LLDAP and Authelia for identity, SSO, and fine-grained access to dashboards and applications.

- **Applications and Services**
  - Core infrastructure services (DNS, DHCP, IdM, observability, databases) live primarily on LAN_Server networks and are not directly internet-exposed.
  - Public or semi-public services (reverse proxy, search, status, speedtest, binary cache, Matrix, minecraft) live in the DMZ and are fronted by HAProxy and Authelia.
  - Data and compute heavy workloads (Spark + HDFS, Llama.cpp, Immich, Jellyfin) use GPU and high-memory nodes but are still defined via the same Proxmox + NixOS pattern.

## How This Repo Models Backwater

- **Infrastructure provisioning (`00-proxmox/`)**
  - OpenTofu configuration defines Proxmox SDN zones/VNets, bridges, storage classes, LXCs, and VMs.
  - This layer focuses on network topology, compute shapes, and storage placement; see `site-backwater/00-proxmox/README.md` for details.

- **NixOS & services (`01-nix/`)**
  - NixOS configurations attach to those Proxmox resources to define system services, firewall rules, and boot-time behavior.
  - Key roles include WireGuard gateway, WiFi gateway, DHCP/DNS, observability stack, identity, and application servers; see `site-backwater/01-nix/README.md`.

- **Application layers**
  - Kubernetes add-ons for the LAN-server cluster live under `01-nix/LAN-server/k8s-server/k8s-addon/` and model cluster-level capabilities like ingress, observability, and storage integrations.
  - Minecraft workloads and their mod definitions in the DMZ live under `01-nix/DMZ/minecraft/` and its `mods/` subdirectory, representing an application layer on top of the backwater infrastructure.

Backwater is thus captured as a set of layered, composable definitions: OpenTofu for Proxmox infrastructure, NixOS for operating system and services, and specialized app directories for higher-level workloads.
