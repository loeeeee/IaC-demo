# Networking Infrastructure Endpoints
# Network: LAN-server (172.22.0.0/24) and DMZ
[
  # ============================================
  # LAN-server Applications (172.22.0.0/24)
  # ============================================
  {
    name = "dhcp-master";
    group = "networking";
    url = "udp://172.22.0.108:67";
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
    name = "unbound-master";
    group = "networking";
    url = "tcp://172.22.0.109:53";
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
    name = "bind";
    group = "networking";
    url = "tcp://172.22.0.110:53";
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
    name = "unbound-backup";
    group = "networking";
    url = "tcp://172.22.0.111:53";
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
    name = "dhcp-backup";
    group = "networking";
    url = "udp://172.22.0.114:67";
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

  # ============================================
  # DMZ Applications (172.22.100.0/24)
  # ============================================
  {
    name = "ws-tunnel";
    group = "networking";
    url = "http://172.22.100.108:8080";
    interval = "60s";
    conditions = [ "[STATUS] == 400" ];
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
