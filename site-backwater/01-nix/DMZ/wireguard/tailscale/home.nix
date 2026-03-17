{ config, lib, pkgs, ... }:

{
  containers.ts-home = {
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

        # Add route for backwater network via transit (for advertised routes)
        ${pkgs.iproute2}/bin/ip route add 172.22.0.0/16 via 192.168.100.6 dev mv-ens19.6 table 100
      '';

      # DNS configuration for internet access
      networking.nameservers = [ "172.22.100.102" "8.8.8.8" ];

      # Disable firewall in container (host handles filtering)
      networking.firewall.enable = false;
      networking.nat.enable = false;

      # Tailscale VPN Client
      # Note: Tailscale interface will be moved to VRF after creation
      services.tailscale = {
        enable = true;
        # authKey = "REDACTED";
        # Configure route advertising for backwater network
        extraUpFlags = [
          "--advertise-routes=172.22.0.0/16"
        ];
        # Userspace networking interface name
        interfaceName = "userspace-networking";
      };

      # Configure Tailscale routing after authentication
      systemd.services.tailscale.after = [ "network.target" ];
      systemd.services.tailscale.postStart = ''
        # Wait for Tailscale to be ready
        sleep 5

        # Add route for advertised subnets to go through transit network
        # This ensures traffic to backwater network goes via VLAN 6
        ${pkgs.iproute2}/bin/ip route add 172.22.0.0/16 via 192.168.100.6 dev mv-ens19.6 || true
      '';

      # Default route via bridge for DMZ/internet access (default VRF)
      networking.defaultGateway = {
        address = "192.168.101.1";
        interface = "eth0";
      };

      # Basic packages for troubleshooting
      environment.systemPackages = with pkgs; [
        tailscale
        tcpdump
        iproute2
      ];

      system.stateVersion = "25.05";
    };
  };
}
