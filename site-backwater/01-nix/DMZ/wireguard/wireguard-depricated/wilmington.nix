{ config, lib, pkgs, ... }:

{
  # WireGuard Site-to-Site Tunnel: Backwater <-> Wilmington
  networking.wg-quick.interfaces = {
    site-wilmington = {
      address = [ "192.168.205.2/24" ];
      
      listenPort = 51820;

      privateKey = "REDACTED";

      peers = [
        {
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "192.168.205.1/32"
            "172.23.0.0/16"
          ];
          # endpoint = "REDACTED:51820";
          endpoint = "172.22.100.108:51231";
        }
      ];
    };
  };
}
