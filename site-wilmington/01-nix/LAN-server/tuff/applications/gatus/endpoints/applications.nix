# Application Endpoints
[
  {
    name = "postfix";
    group = "applications";
    url = "tcp://127.0.0.1:465";
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
    name = "binary-cache";
    group = "applications";
    url = "http://127.0.0.1:5000";
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
    name = "gatus";
    group = "applications";
    url = "http://127.0.0.1:5001";
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
    group = "applications";
    url = "http://127.0.0.1:5002";
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
