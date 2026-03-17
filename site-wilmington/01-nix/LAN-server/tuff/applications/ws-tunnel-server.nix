{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wstunnel ];

  systemd.services.wstunnel-server = {
    description = "wstunnel server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wstunnel}/bin/wstunnel server ws://127.0.0.1:8443 --restrict-to 127.0.0.1:51820";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
    };
  };
}

