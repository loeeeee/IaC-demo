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
    # VLAN 2: ToWilmington transit network (used by wg-wilm container)
    "ens19.2" = {
      id = 2;
      interface = "ens19";
    };
    
    # VLAN 6: ToHome transit network (not currently used)
    "ens19.6" = {
      id = 6;
      interface = "ens19";
    };
    
    # VLAN 14: Remote Access transit network (used by wg-remote container)
    "ens19.14" = {
      id = 14;
      interface = "ens19";
    };
    
    # VLAN 18: Proton VPN Memphis transit network (used by wg-memphis container)
    "ens19.18" = {
      id = 18;
      interface = "ens19";
    };
    
    # VLAN 22: Proton VPN Hong Kong transit network (used by wg-hk container)
    "ens19.22" = {
      id = 22;
      interface = "ens19";
    };
    
    # VLAN 26: Proton VPN Berlin transit network (used by wg-berlin container)
    "ens19.26" = {
      id = 26;
      interface = "ens19";
    };
    
    # VLAN 30: Proton VPN Tokyo transit network (used by wg-tokyo container)
    "ens19.30" = {
      id = 30;
      interface = "ens19";
    };

    # VLAN 34: Proton VPN Seoul transit network (used by wg-seoul container)
    "ens19.34" = {
      id = 34;
      interface = "ens19";
    };

    # VLAN 38: Proton VPN Taipei transit network (used by wg-taipei container)
    "ens19.38" = {
      id = 38;
      interface = "ens19";
    };
  };

  # No IP addresses on VLAN interfaces - containers attach directly via macvlan
}