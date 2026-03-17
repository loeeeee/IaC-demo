{ config, lib, pkgs, modulesPath, ... }:

{
  # Configure network interfaces
  # ens18: DMZ network (default gateway via DHCP)
  networking.interfaces.ens18.useDHCP = lib.mkDefault true;

  # ens19: Transit trunk interface (no IP, VLANs configured below)
  networking.interfaces.ens19.useDHCP = lib.mkDefault false;

  # Create bridge for container internet/DMZ access
  networking.bridges.br-wg = {
    interfaces = [ ];  # Container veth interfaces will be added automatically
  };

  networking.interfaces.br-wg.ipv4.addresses = [{
    address = "192.168.101.1";
    prefixLength = 24;
  }];

  # VLAN subinterfaces on ens19 (pure L2 segments for container macvlan attachment)
  networking.vlans = {
    # VLAN 6: ToBackwater transit network (used by wg-backwater container)
    "ens19.6" = {
      id = 6;
      interface = "ens19";
    };

    # VLAN 10: Vanderbilt WiFi transit network (future use)
    "ens19.10" = {
      id = 10;
      interface = "ens19";
    };

    # VLAN 14: Remote Access transit network (future use)
    "ens19.14" = {
      id = 14;
      interface = "ens19";
    };
  };

  # No IP addresses on VLAN interfaces - containers attach directly via macvlan
}
