{ config, lib, pkgs, ... }:

{
  # WireGuard Site-to-Site Tunnel: Backwater <-> Wilmington
  networking.wg-quick.interfaces = {
    site-seattle = {
      address = [ "192.168.207.2/24" ];
      
      listenPort = 51823;

      privateKey = "REDACTED";

      peers = [
        {
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "192.168.207.1/32"
          ];
        }
      ];
    };
  };
}
