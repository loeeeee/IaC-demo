# Data Processing Endpoints (Spark Cluster)
# Network: LAN-server (172.22.0.0/24)
[
  # ============================================
  # Spark Master
  # ============================================
  {
    name = "spark master";
    group = "data processing";
    url = "http://172.22.0.136:8080";
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
    name = "spark connect server";
    group = "data processing";
    url = "tcp://172.22.0.136:15002";
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
  # Spark Workers
  # ============================================
  {
    name = "spark worker 1";
    group = "data processing";
    url = "http://172.22.0.137:8081";
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
    name = "spark worker 2";
    group = "data processing";
    url = "http://172.22.0.138:8081";
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
