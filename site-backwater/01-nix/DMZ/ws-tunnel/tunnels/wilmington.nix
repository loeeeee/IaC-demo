{ config, pkgs, ... }:

{
  systemd.services.wstunnel-wilmington = {
    description = "wstunnel client to wilmington (wilmington.REDACTED-DOMAIN.TLD)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wstunnel}/bin/wstunnel client -L udp://172.22.100.108:51002:127.0.0.1:51820 -P ws --tls-sni-override www.acfun.cn --dns-resolver dns+https://1.1.1.1?sni=cloudflare-dns.com wss://wilmington.REDACTED-DOMAIN.TLD";
      Restart = "always";
      RestartSec = 5;
      DynamicUser = true;
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    };
  };
}
