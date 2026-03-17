# Data Storage Endpoints
# Network: LAN-server (172.22.0.0/24)
[
  {
    name = "postgresql";
    group = "data storage";
    url = "tcp://172.22.0.133:5432";
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
    name = "redis-main";
    group = "data storage";
    url = "tcp://172.22.0.140:6379";
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
    name = "redis-immich";
    group = "data storage";
    url = "tcp://172.22.0.140:6380";
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
]
