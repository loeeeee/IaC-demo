# Backwater Minecraft Mods Layer (DMZ)

This directory defines the mod set for the backwater Minecraft servers running in the DMZ. It represents an application layer built on top of the site’s DMZ infrastructure and NixOS services.

## Overview

- **Goal**: Declaratively specify the Minecraft modpack (jars and versions) used by the backwater servers.
- **Scope**: Mod artifacts and groupings only — server lifecycle, networking, and storage are configured elsewhere in the NixOS roles for the Minecraft host.

## Architecture Layers (for this directory)

- **Application**
  - Each mod is defined as a small Nix expression (typically using `pkgs.fetchurl`) that pins the download URL and hash for a specific jar.
  - `_init_.nix` files aggregate these mods into lists that the Minecraft server configuration imports.
  - Mods are grouped conceptually into areas like:
    - **Core / libraries** (e.g., Fabric API, language and loader libraries).
    - **World generation & structures** (e.g., terrain, biomes, dungeons, villages).
    - **Gameplay mechanics** (e.g., farming, vehicles, combat tweaks).
    - **Sound & visuals** (e.g., soundscape and visual enhancements).

- **Infrastructure dependencies**
  - The Minecraft server itself runs as a NixOS service on a DMZ LXC/VM defined in:
    - Proxmox + OpenTofu: `site-backwater/00-proxmox/`.
    - NixOS host configuration: `site-backwater/01-nix/DMZ/minecraft/`.
  - Storage for worlds and backups is provided by ZFS-backed volumes, attached at the Proxmox layer and mounted by NixOS.

## Relationship to Other Layers

- **Underneath**
  - Relies on DMZ networking (Proxmox SDN + PFsense) and HAProxy for exposure, as described at the site and Proxmox layers.
  - Uses NixOS service definitions to configure the Minecraft server, JVM options, and integration with monitoring/logging.

- **Alongside**
  - Coexists with other DMZ application workloads (e.g., reverse proxy, search, status pages) that may front or monitor the Minecraft servers.

## Editing and Extending Mods

- To add or change mods:
  - Create or update the appropriate `.nix` file for the mod, pinning the download URL and hash.
  - Reference it from the relevant `_init_.nix` so it is included in the server’s modpack.
- For detailed helper commands (e.g., prefetching hashes or using Modrinth tooling), refer to the NixOS minecraft configuration under `site-backwater/01-nix/DMZ/minecraft/` or supporting documentation in this repo.

This README is intended as a high-level map; use the individual mod files and `_init_.nix` aggregators for concrete implementation details.

