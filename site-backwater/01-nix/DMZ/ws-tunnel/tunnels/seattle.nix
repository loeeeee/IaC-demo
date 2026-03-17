{ config, pkgs, ... }:

{
  systemd.services.wstunnel-seattle = {
    description = "wstunnel client to seattle (blog.REDACTED-DOMAIN2.TLD)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wstunnel}/bin/wstunnel client -L udp://172.22.100.108:51230:127.0.0.1:51820 --http-upgrade-path-prefix ws wss://blog.REDACTED-DOMAIN2.TLD";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    };
  };
}
