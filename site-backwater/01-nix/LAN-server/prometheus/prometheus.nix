{ config, pkgs, modulesPath, lib, ... }:

{
  # Configure user prometheus
  users.groups.prometheus = {
    gid = lib.mkForce 2350;
  };
  users.users.prometheus = {
    isSystemUser = true;
    uid = lib.mkForce 2350;
    group = "prometheus";
    home = lib.mkDefault "/var/lib/prometheus";
    createHome = true;
  };

  services.prometheus = {
    enable = true;
    stateDir = "prometheus";  # Just the directory name, NixOS prepends /var/lib/
    retentionTime = "30d";  # Retain metrics for 30 days
    listenAddress = "0.0.0.0";  # Listen on all IPv4 interfaces
    port = 8080;
    globalConfig = {
      scrape_interval = "15s";
      evaluation_interval = "15s";
    };
    extraFlags = [
      "--web.enable-otlp-receiver" # Enable OTLP receiver for Prometheus to receive metrics from other services
      "--web.enable-remote-write-receiver"
    ];
    scrapeConfigs = [
      # {
      #   job_name = "prometheus";
      #   static_configs = [{
      #     targets = [ "localhost:9090" ];
      #   }];
      # }
      {
        job_name = "nix-binary-cache";
        scheme = "http"; # Use "http" if your server does not have SSL
        # metrics_path = "/metrics";
        static_configs = [{
          targets = [ "172.22.100.105:8080" ];
        }];
      }
      {
        job_name = "pfsense";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.1:9167" ];
        }];
      }
      {
        job_name = "postgresql";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.133:9167" ];
        }];
      }
      {
        job_name = "dhcp-master";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.108:9167" ];
        }];
      }
      {
        job_name = "dhcp-backup";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.114:9167" ];
        }];
      }
      {
        job_name = "unbound-master";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.109:9167" ];
        }];
      }
      {
        job_name = "unbound-backup";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.111:9167" ];
        }];
      }
      {
        job_name = "bind";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.110:9167" ];
        }];
      }
      {
        job_name = "gatus";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.0.117:8080" ];
        }];
      }
      {
        job_name = "haproxy";
        scheme = "http";
        static_configs = [{
          targets = [ "172.22.100.110:9167" ];
        }];
      }
    ];
  };
}

