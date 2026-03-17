# Backwater Kubernetes Add-on Layer (LAN-Server)

This directory defines Kubernetes add-ons that run on the backwater LAN-server cluster. It represents the cluster-level application layer that sits on top of the core Proxmox + NixOS + Kubernetes stack.

## Overview

- **Goal**: Provide a curated set of add-ons (networking, ingress, observability, storage, and apps) for the LAN-server Kubernetes cluster.
- **Scope**: NixOS/Kubernetes configurations that extend the base cluster with shared services rather than one-off workloads.

## Architecture Layers (for this directory)

- **Network & ingress**
  - Ingress controllers, service meshes, and related networking components that expose cluster services to LAN_Server or DMZ.
  - Integrates with existing Proxmox SDN and NixOS firewall rules; traffic typically reaches this layer through HAProxy or directly from LAN_Server.

- **Observability**
  - Cluster-level metrics, logging, and tracing add-ons that complement the site-wide observability stack (Prometheus, Grafana, VictoriaLogs, Gatus).
  - Focus is on standardized telemetry for all workloads running on the LAN-server cluster.

- **Storage**
  - CSI drivers and storage abstractions that bind to underlying ZFS-backed storage on Proxmox nodes.
  - The aim is to provide a small set of well-understood storage classes instead of many bespoke ones.

- **Applications**
  - Shared services and internal apps that are best run as Kubernetes workloads on LAN_Server rather than as individual LXCs/VMs.
  - Examples may include internal dashboards, batch jobs, or services that benefit from Kubernetes scheduling and rolling updates.

## Relationship to Other Layers

- **Underneath**
  - Runs on NixOS hosts defined in `site-backwater/01-nix/LAN-server/k8s-server/`, which in turn run as Proxmox VMs/LXCs defined in `site-backwater/00-proxmox/`.
  - Networking and storage capabilities are inherited from those lower layers.

- **Alongside**
  - Complements, but does not replace, standalone NixOS services on LAN_Server and DMZ (e.g., DNS, DHCP, reverse proxy, databases).

## Where to Look for Details

- Raw Kubernetes manifests or higher-level specs are organized into subdirectories here.
- If YAML is generated from other formats, follow any `_raw` or `raw/` subdirectories and their notes for edit rules.

Use this README as a conceptual map; consult individual subdirectories for concrete add-on configurations.
