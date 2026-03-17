{ config, lib, pkgs, ... }:

{
  # WireGuard Remote Access Tunnel
  networking.wg-quick.interfaces = {
    remote-access = {
      address = [ "172.22.2.0/24" ];
      
      listenPort = 51822;

      privateKey = "REDACTED";

      peers = [
        # Loe's devices
        {
          # OnePlus 12
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "172.22.2.2/32"
          ];
        }
        {
          # Pixel 7 Pro
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "172.22.2.3/32"
          ];
        }
        {
          # Spectre x360 14
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "172.22.2.4/32"
          ];
        }
        {
          # Quest 3
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "172.22.2.5/32"
          ];
        }
      ];
    };
  };
}
