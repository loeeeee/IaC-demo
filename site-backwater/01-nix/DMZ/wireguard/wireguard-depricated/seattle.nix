{ config, lib, pkgs, ... }:

{
  # WireGuard Site-to-Site Tunnel: Backwater <-> Wilmington
  networking.wg-quick.interfaces = {
    site-seattle = {
      address = [ "192.168.208.2/24" ];
      
      listenPort = 51826;

      privateKey = "REDACTED";

      peers = [
        {
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "192.168.208.1/32"
          ];
          endpoint = "172.22.100.108:51230";
        }
      ];
    };
  };
}
