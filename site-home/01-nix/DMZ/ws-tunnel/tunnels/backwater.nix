{ config, pkgs, ... }:

{
  systemd.services.wstunnel-backwater = {
    description = "wstunnel backwater";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wstunnel}/bin/wstunnel client -L udp://0.0.0.0:1988:172.22.100.112:51006 -P ws --tls-sni-override backwater.REDACTED-DOMAIN.TLD --dns-resolver dns://1.1.1.1 wss://backwater.REDACTED-DOMAIN.TLD:443";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
    };
  };
}

