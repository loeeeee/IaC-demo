# WireGuard Gateway Template
# This function creates a container configuration for a WireGuard VPN gateway
{
  locationName,
  vlan,
  wgInterfaceName,
  wgPrivateKey,
  wgPublicKey,
  wgEndpoint,
  vpnLocationId
}: { config, lib, pkgs, ... }: let
  # Calculate IP addresses based on VLAN
  localAddress = "192.168.101.${toString vlan}/24";
  transitIp = "192.168.100.${toString (vlan - 1)}";
  transitGateway = "192.168.100.${toString vlan}";
  natCidr = "192.168.100.${toString (vlan - 2)}/30";
  containerName = "wg-${locationName}";
in {
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br-wg";
    localAddress = localAddress;

    # Attach directly to VLAN transit network using macvlan
    macvlans = [ "ens19.${toString vlan}" ];

    config = { config, pkgs, ... }: {
      # Configure IP address on macvlan interface for transit network
      networking.interfaces."mv-ens19.${toString vlan}".ipv4.addresses = [{
        address = transitIp;
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
        ${pkgs.iproute2}/bin/ip link set mv-ens19.${toString vlan} master vrf-transit || true

        # Add return route to backwater networks via transit peer in VRF
        ${pkgs.iproute2}/bin/ip route add 172.22.0.0/16 via ${transitGateway} dev mv-ens19.${toString vlan} table 100
      '';

      # Disable firewall in container (host handles filtering)
      networking.firewall.enable = false;

      # Proton VPN ${locationName}
      # Note: WireGuard interface will be moved to VRF after creation
      networking.wg-quick.interfaces.${wgInterfaceName} = {
        address = [ "10.2.0.2/32" ];

        privateKey = wgPrivateKey;
        table = "off";

        postUp = ''
          # Add WireGuard interface to VRF
          ${pkgs.iproute2}/bin/ip link set ${wgInterfaceName} master vrf-transit
          # Add default route to VRF
          ${pkgs.iproute2}/bin/ip route add default dev ${wgInterfaceName} table 100

          # Add NAT for outbound traffic through VPN
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 172.22.0.0/16 -o ${wgInterfaceName} -j MASQUERADE
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${natCidr} -o ${wgInterfaceName} -j MASQUERADE
        '';

        preDown = ''
          # Clean up NAT rule
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 172.22.0.0/16 -o ${wgInterfaceName} -j MASQUERADE || true
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${natCidr} -o ${wgInterfaceName} -j MASQUERADE || true
        '';

        peers = [
          {
            # ${vpnLocationId}
            publicKey = wgPublicKey;
            allowedIPs = [
              "0.0.0.0/0"
            ];
            endpoint = wgEndpoint;
          }
        ];
      };

      # Default route via bridge for internet access (default VRF)
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
