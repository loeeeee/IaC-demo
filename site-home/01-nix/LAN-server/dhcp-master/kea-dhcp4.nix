{ config, pkgs, lib, ... }:

{
  # Create static kea user and group to avoid DynamicUser race conditions
  users.groups.kea = {};
  users.users.kea = {
    isSystemUser = true;
    group = "kea";
    home = "/var/lib/kea";
  };

  # Override Kea systemd services to use static user instead of DynamicUser
  # This prevents race conditions where services start before RuntimeDirectory is ready
  # Also disable RuntimeDirectory/StateDirectory since we manage them via tmpfiles
  systemd.services.kea-dhcp4-server.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "kea";
    Group = lib.mkForce "kea";
    RuntimeDirectory = lib.mkForce "";
    StateDirectory = lib.mkForce "";
  };
  systemd.services.kea-dhcp-ddns-server.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "kea";
    Group = lib.mkForce "kea";
    RuntimeDirectory = lib.mkForce "";
    StateDirectory = lib.mkForce "";
  };
  systemd.services.kea-ctrl-agent.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "kea";
    Group = lib.mkForce "kea";
    RuntimeDirectory = lib.mkForce "";
    StateDirectory = lib.mkForce "";
  };
  systemd.services.prometheus-kea-exporter.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "kea";
    Group = lib.mkForce "kea";
    RuntimeDirectory = lib.mkForce "";
  };

  services.kea = {

    ctrl-agent = {
      enable = true;
      settings = {
        "http-host" = "172.21.0.129";
        "http-port" = 8000;
        # The CA needs to know where to send commands intended for DHCP4
        "control-sockets" = {
          "dhcp4" = {
            "socket-type" = "unix";
            "socket-name" = "/run/kea/dhcp4.sock";
          };
        };
      };
    };
    
    dhcp4 = {
      enable = true;
      settings = {
        # Basics
        "interfaces-config" = {
          "interfaces" = [ "eth0" ];
        };
        "lease-database" = {
          "type" = "memfile";
          "persist" = true;
          "name" = "/var/lib/kea/dhcp4.leases";
        };
        "valid-lifetime" = 28800; # 8 hours
        "renew-timer" = 10000; # ~2.78 hours
        "rebind-timer" = 15000; # ~4.17 hours
        
        # DDNS
        "ddns-qualifying-suffix" = "home.REDACTED-DOMAIN.TLD";
        
        # DDNS configuration - tells DHCPv4 server how to communicate with D2 server
        # Note: The D2 server (kea-dhcp-ddns) must be configured separately
        # In KEA 3.0+, qualifying-suffix moved to global scope as ddns-qualifying-suffix
        "dhcp-ddns" = {
          "enable-updates" = true;
          "server-ip" = "127.0.0.1";  # D2 server runs locally
          "server-port" = 53001;     # Default D2 server port
          "sender-ip" = "172.21.0.129";
          "sender-port" = 0;
        };

        # Control Socket
        "control-socket" = {
          "socket-type" = "unix";
          "socket-name" = "/run/kea/dhcp4.sock";
        };
        
        # High Availability
        "hooks-libraries" = [
          {
            "library" = "${pkgs.kea}/lib/kea/hooks/libdhcp_lease_cmds.so";
          }
          {
            "library" = "${pkgs.kea}/lib/kea/hooks/libdhcp_stat_cmds.so";
          }
          {
            "library" = "${pkgs.kea}/lib/kea/hooks/libdhcp_ha.so";
            "parameters" = {
              "high-availability" = [
                {
                  "this-server-name" = "edogawa";
                  "mode" = "hot-standby";
                  "heartbeat-delay" = 1000;
                  "max-response-delay" = 5000;
                  "max-ack-delay" = 10000;
                  "max-unacked-clients" = 0;
                  "peers" = [
                    {
                      "name" = "edogawa";
                      "url" = "http://172.21.0.129:8001/";
                      "role" = "primary";
                      "auto-failover" = true;
                    }
                    {
                      "name" = "adachi";
                      "url" = "http://172.21.0.130:8001/";
                      "role" = "standby";
                      "auto-failover" = true;
                    }
                  ];
                }
              ];
            };
          }
        ];

        # Subnets
        "subnet4" = import ./kea-dhcp4-subnet4.nix;

        # Logging
        "loggers" = [
          {
            "name" = "kea-dhcp4";
            "output_options" = [
              {
                "output" = "/var/log/kea/kea-dhcp4.log";
                "maxver" = 10;
                "maxsize" = 10485760; # 10 MB
              }
            ];
            "severity" = "INFO";
          }
        ];
      };
    };
  };


  # Create directories for Kea (using static kea user, not DynamicUser)
  systemd.tmpfiles.rules = [
    "d /run/kea 0750 kea kea -"
    "d /var/lib/kea 0750 kea kea -"
    "d /var/log/kea 0750 kea kea -"
  ];
}

