# Monitoring Stack Endpoints
# Network: LAN-server (172.22.0.0/24) and localhost
[
  # ============================================
  # Local Services
  # ============================================
  {
    name = "gatus";
    group = "monitoring";
    url = "http://127.0.0.1:8080";
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

  # ============================================
  # LAN-server Monitoring Stack (172.22.0.0/24)
  # ============================================
  {
    name = "prometheus";
    group = "monitoring";
    url = "http://172.22.0.112:8080";
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
    name = "victorialogs";
    group = "monitoring";
    url = "http://172.22.0.107:9428";
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
