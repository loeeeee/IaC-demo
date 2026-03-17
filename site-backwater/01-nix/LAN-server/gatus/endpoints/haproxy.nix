# HAProxy Frontend Domain Endpoints
# External domains through HAProxy
[
  {
    name = "proxmox";
    group = "haproxy";
    url = "https://virtualization.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "pfsense";
    group = "haproxy";
    url = "https://wall.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "jellyfin";
    group = "haproxy";
    url = "https://media.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "qbittorrent";
    group = "haproxy";
    url = "https://downloader.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "code";
    group = "haproxy";
    url = "https://code.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "nixcache";
    group = "haproxy";
    url = "https://nix.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "grafana";
    group = "haproxy";
    url = "https://grafana.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "prometheus";
    group = "haproxy";
    url = "https://prometheus.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "base";
    group = "haproxy";
    url = "https://backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "speedtest";
    group = "haproxy";
    url = "https://speed.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "lldap";
    group = "haproxy";
    url = "https://lldap.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "authelia";
    group = "haproxy";
    url = "https://auth.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "photos";
    group = "haproxy";
    url = "https://photos.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "sunshine";
    group = "haproxy";
    url = "https://sunshine.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 401" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "spark";
    group = "haproxy";
    url = "https://spark.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "status";
    group = "haproxy";
    url = "https://status.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "searxng";
    group = "haproxy";
    url = "https://search.backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "openai";
    group = "haproxy";
    url = "https://openai.backwater.REDACTED-DOMAIN.TLD/v1/models";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "claw";
    group = "haproxy";
    url = "https://claw.backwater.REDACTED-DOMAIN.TLD/health";
    interval = "60s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "haproxy";
    group = "haproxy";
    url = "tcp://172.22.100.110:443";
    interval = "30s";
    conditions = [ "[CONNECTED] == true" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "haproxy-metrics";
    group = "haproxy";
    url = "http://172.22.100.110:9167/metrics";
    interval = "30s";
    conditions = [ "[STATUS] == 200" ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
  {
    name = "certification";
    group = "haproxy";
    url = "https://backwater.REDACTED-DOMAIN.TLD";
    interval = "60s";
    conditions = [ 
      "[CONNECTED] == true" 
      "[CERTIFICATE_EXPIRATION] > 168h" 
    ];
    alerts = [
      {
        type = "email";
      }
      {
        type = "discord";
      }
    ];
  }
]
