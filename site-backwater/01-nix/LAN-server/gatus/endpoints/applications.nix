# Application Endpoints
# Mixed network locations: DMZ (172.22.100.0/24) and LAN-server (172.22.0.0/24)
[
  # ============================================
  # DMZ Applications (172.22.100.0/24)
  # ============================================
  {
    name = "binary-cache";
    group = "applications";
    url = "http://172.22.100.105:8080";
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
    group = "applications";
    url = "http://172.22.100.106:8080";
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
    name = "dufs";
    group = "applications";
    url = "http://172.22.100.107:8080";
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
    name = "speedtest";
    group = "applications";
    url = "http://172.22.100.109:8080";
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
    name = "email-forwarder";
    group = "applications";
    url = "tcp://172.22.100.111:25";
    interval = "60s";
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
    name = "searxng";
    group = "applications";
    url = "http://172.22.100.114:8080";
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
    name = "open-amplify-ai";
    group = "applications";
    url = "http://172.22.100.116:8080/v1/models";
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
    group = "applications";
    url = "http://172.22.100.115:8080/health";
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
    name = "minecraft";
    group = "applications";
    url = "tcp://172.22.100.118:25565";
    interval = "60s";
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

  # ============================================
  # LAN-server Applications (172.22.0.0/24)
  # ============================================
  {
    name = "grafana";
    group = "applications";
    url = "http://172.22.0.113:8080";
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
    name = "code-server";
    group = "applications";
    url = "http://172.22.0.130:8080";
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
    name = "immich";
    group = "applications";
    url = "http://172.22.0.131:8080";
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
    name = "jellyfin";
    group = "applications";
    url = "http://172.22.0.132:8080";
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
]
