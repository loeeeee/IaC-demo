{ config, pkgs, ... }:

{
  # IP forwarding is already enabled in configuration.nix via boot.kernel.sysctl
  # This module handles routing policy and additional routing rules

  # Enable packet forwarding between interfaces
  # This is handled by nftables rules in nftables.nft

  # Optional: Add static routes if needed
  # networking.interfaces.ens19.ipv4.routes = [
  #   {
  #     address = "192.168.100.8";
  #     prefixLength = 30;
  #   }
  # ];

  # The actual routing and NAT is handled by nftables
  # See nftables.nft for forwarding and masquerading rules
}

