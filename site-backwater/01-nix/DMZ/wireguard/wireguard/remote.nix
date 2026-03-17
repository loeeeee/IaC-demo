{ config, lib, pkgs, ... }:

{
  containers.wg-remote = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-wg";
    localAddress = "192.168.101.13/24";
    
    # Attach directly to VLAN 14 transit network using macvlan
    macvlans = [ "ens19.14" ];

    config = { config, pkgs, ... }: {
      # Configure IP address on macvlan interface for transit network
      networking.interfaces."mv-ens19.14".ipv4.addresses = [{
        address = "192.168.100.13";
        prefixLength = 30;
      }];
      
      # Enable IP forwarding in container
      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv4.conf.default.forwarding" = 1;
        "net.ipv4.conf.all.rp_filter" = 2;
        "net.ipv4.conf.default.rp_filter" = 2;
      };

      # Create VRF for transit network isolation
      networking.localCommands = ''
        # Create VRF for transit network
        ${pkgs.iproute2}/bin/ip link add vrf-transit type vrf table 100 || true
        ${pkgs.iproute2}/bin/ip link set vrf-transit up || true
        
        # Move macvlan interface to VRF
        ${pkgs.iproute2}/bin/ip link set mv-ens19.14 master vrf-transit || true

        # Add default route to VRF
        ${pkgs.iproute2}/bin/ip route add default via 192.168.100.14 dev mv-ens19.14 table 100
      '';

      # Disable firewall in container (host handles filtering)
      networking.firewall.enable = false;
      networking.nat.enable = false;

      # WireGuard Remote Access Tunnel
      # Note: WireGuard interface will be moved to VRF after creation
      networking.wg-quick.interfaces = {
        remote-access = {
          address = [ "172.22.2.0/24" ];
          
          listenPort = 51014;

          privateKey = "REDACTED";
          table = "off";

          postUp = ''
            # Add WireGuard interface to VRF
            ${pkgs.iproute2}/bin/ip link set remote-access master vrf-transit

            # Add return route to backwater networks via transit peer in VRF
            # ${pkgs.iproute2}/bin/ip route add 172.22.2.0/24 dev remote-access table 100
          '';

          peers = [
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

      # Default route via bridge for DMZ/internet access (default VRF)
      networking.defaultGateway = {
        address = "192.168.101.1";
        interface = "eth0";
      };

      # Basic packages for troubleshooting
      environment.systemPackages = with pkgs; [
        wireguard-tools
        tcpdump
        iproute2
      ];

      system.stateVersion = "25.05";
    };
  };
}

