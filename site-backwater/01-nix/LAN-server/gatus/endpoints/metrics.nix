# Promethus Metrics Endpoints
# Metrics exporter
[
  # ============================================
  # DMZ Applications (172.22.100.0/24)
  # ============================================
  {
    name = "haproxy";
    group = "metrics";
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

  # ============================================
  # LAN-server Applications (172.22.0.0/24)
  # ============================================
  {
    name = "pfsense";
    group = "metrics";
    url = "http://172.22.0.1:9167/metrics";
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
    name = "bind";
    group = "metrics";
    url = "http://172.22.0.110:9167/metrics";
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
    name = "unbound-master";
    group = "metrics";
    url = "http://172.22.0.109:9167/metrics";
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
    name = "unbound-backup";
    group = "metrics";
    url = "http://172.22.0.111:9167/metrics";
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
    name = "dhcp-master";
    group = "metrics";
    url = "http://172.22.0.108:9167/metrics";
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
    name = "dhcp-backup";
    group = "metrics";
    url = "http://172.22.0.114:9167/metrics";
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
]
