{ config, lib, pkgs, ... }:

{
  # Enable IP forwarding for VPN functionality
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.forwarding" = 1;
  };

  # Install WireGuard tools
  environment.systemPackages = with pkgs; [
    wireguard-tools
    tcpdump
  ];

  # Configure WireGuard interface
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "192.168.205.1/24" ];
      listenPort = 51820;

      # Server private key
      privateKey = "REDACTED";

      # Define peers (clients)
      peers = [
        {
          # Client 1: 192.168.205.2
          publicKey = "REDACTED";
          presharedKey = "REDACTED";
          allowedIPs = [
            "192.168.205.2/32"
            "192.168.100.0/30"
            "172.22.0.0/16"
          ];
          # endpoint = "backwater.REDACTED-DOMAIN2.TLD:51824"; # Just in case
        }
      ];
    };
  };
}
