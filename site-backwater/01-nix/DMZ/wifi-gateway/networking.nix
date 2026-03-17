{ config, lib, pkgs, modulesPath, ... }:

{
  # Configure three network interfaces
  # ens18: DMZ network (default gateway via DHCP)
  networking.interfaces.ens18.useDHCP = lib.mkDefault true;
  
  # ens19: vandy transit network (manual config)
  networking.interfaces.ens19.useDHCP = lib.mkDefault false;
  networking.interfaces.ens19.ipv4.addresses = [{
    address = "192.168.100.9";
    prefixLength = 30;
  }];

  # wls16: WiFi interface connected to vuNet (DHCP)
  networking.interfaces.wls16.useDHCP = lib.mkDefault true;
}

