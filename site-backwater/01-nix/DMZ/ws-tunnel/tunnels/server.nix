{ config, pkgs, ... }:

{
  systemd.services.wstunnel-server = {
    description = "wstunnel server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wstunnel}/bin/wstunnel server ws://0.0.0.0:8080 --restrict-to 172.22.100.112:51006 --restrict-to 172.22.100.112:51002";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
    };
  };
}

