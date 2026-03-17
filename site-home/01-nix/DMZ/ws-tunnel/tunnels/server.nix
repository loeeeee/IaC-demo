{ config, pkgs, ... }:

{
  systemd.services.wstunnel-server = {
    description = "wstunnel server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wstunnel}/bin/wstunnel server ws://0.0.0.0:8080 --restrict-to 172.21.1.1:51820";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
    };
  };
}

