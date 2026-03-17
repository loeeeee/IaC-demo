{ config, pkgs, modulesPath, lib, ... }:

{
  # Configure user grafana
  users.groups.grafana = {
    gid = lib.mkForce 2351;
  };
  users.users.grafana = {
    isSystemUser = true;
    uid = lib.mkForce 2351;
    group = "grafana";
    home = lib.mkDefault "/var/lib/grafana";
    createHome = true;
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";  # Listen on all interfaces
        http_port = 8080;
        domain = "localhost";
        root_url = "http://localhost:8080/";
      };
      security = {
        admin_user = "admin";
      };
    };
    dataDir = "/var/lib/grafana";

    # Install VictoriaLogs datasource plugin declaratively
    declarativePlugins = with pkgs.grafanaPlugins; [
      victoriametrics-logs-datasource
    ];

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://172.22.0.112:8080";
          isDefault = true;
          editable = true;
        }
        {
          name = "VictoriaLogs";
          type = "victoriametrics-logs-datasource"; # Worst name ever
          access = "proxy";
          url = "http://172.22.0.107:9428";
          editable = true;
        }
      ];
    };
  };
}

