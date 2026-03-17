# Monitoring Stack Endpoints
# Network: localhost
[
  {
    name = "gatus";
    group = "monitoring";
    url = "http://127.0.0.1:5001";
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
