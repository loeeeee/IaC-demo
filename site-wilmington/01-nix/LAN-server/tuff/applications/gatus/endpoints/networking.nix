# Networking Infrastructure Endpoints
# Network: localhost
[

  {
    name = "bind";
    group = "networking";
    url = "tcp://127.0.0.1:53";
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
    name = "ws-tunnel";
    group = "networking";
    url = "http://127.0.0.1:8443";
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
