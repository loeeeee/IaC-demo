{ config, pkgs, ... }:

{
  systemd.services.wstunnel-home = {
    description = "wstunnel client to home";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wstunnel}/bin/wstunnel client -L udp://172.22.100.108:51006:172.21.1.1:51820 -P ws --tls-sni-override www.acfun.cn --dns-resolver dns+https://1.1.1.1?sni=cloudflare-dns.com wss://home.REDACTED-DOMAIN.TLD:8443";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    };
  };
}
