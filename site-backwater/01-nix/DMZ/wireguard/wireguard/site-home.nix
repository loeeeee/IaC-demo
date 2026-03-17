{ config, lib, pkgs, ... }:

{
  containers.wg-home = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-wg";
    localAddress = "192.168.101.6/24";
    
    # Attach directly to VLAN 6 transit network using macvlan
    macvlans = [ "ens19.6" ];

    config = { config, pkgs, ... }: {
      # Configure IP address on macvlan interface for transit network
      networking.interfaces."mv-ens19.6".ipv4.addresses = [{
        address = "192.168.100.5";
        prefixLength = 30;
      }];
      # networking.interfaces."mv-ens19.2".useDHCP = false;
      
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
        ${pkgs.iproute2}/bin/ip link set mv-ens19.6 master vrf-transit || true

        # Add return route to networks via transit peer in VRF
        ${pkgs.iproute2}/bin/ip route add 172.22.0.0/16 via 192.168.100.6 dev mv-ens19.6 table 100
        ${pkgs.iproute2}/bin/ip route add 192.168.0.0/24 via 192.168.100.6 dev mv-ens19.6 table 100
      '';

      # Disable firewall in container (host handles filtering)
      networking.firewall.enable = false;
      networking.nat.enable = false;

      # WireGuard Site-to-Site Tunnel: Backwater <-> Home
      # Note: WireGuard interface will be moved to VRF after creation
      networking.wg-quick.interfaces = {
        site-home = {
          address = [ "192.168.204.2/24" ];
          
          # listenPort = 51006;

          privateKey = "REDACTED";
          table = "off";

          postUp = ''
            # Add WireGuard interface to VRF
            ${pkgs.iproute2}/bin/ip link set site-home master vrf-transit
            # Add default route to VRF
            ${pkgs.iproute2}/bin/ip route add default via 192.168.204.1 dev site-home table 100
          '';

          peers = [
            {
              publicKey = "REDACTED";
              presharedKey = "REDACTED";
              allowedIPs = [
                "0.0.0.0/0"
              ];
              endpoint = "172.22.100.108:51006";
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

