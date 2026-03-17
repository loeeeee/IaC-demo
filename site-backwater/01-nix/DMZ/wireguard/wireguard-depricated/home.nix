{ config, lib, pkgs, ... }:

{
  # WireGuard Site-to-Site Tunnel: Backwater <-> Home
  networking.wg-quick.interfaces = {
    site-home = {
      address = [ "192.168.204.2/24" ];
      
      listenPort = 51821;

      privateKey = "REDACTED";

      peers = [
        {
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "172.21.0.0/16"
            "192.168.204.0/24"
          ];
          endpoint = "172.22.100.108:51232";
        }
      ];
    };
  };
}

