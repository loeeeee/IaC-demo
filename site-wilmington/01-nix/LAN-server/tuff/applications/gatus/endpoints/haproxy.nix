# HAProxy Frontend Domain Endpoints
# External domains through HAProxy
[
  {
    name = "nixcache";
    group = "haproxy";
    url = "https://nix.wilmington.REDACTED-DOMAIN.TLD";
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
    url = "https://wilmington.REDACTED-DOMAIN.TLD";
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
    url = "https://speed.wilmington.REDACTED-DOMAIN.TLD";
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
    url = "https://status.wilmington.REDACTED-DOMAIN.TLD";
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
    url = "tcp://172.23.0.2:443";
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
    name = "certification";
    group = "haproxy";
    url = "https://wilmington.REDACTED-DOMAIN.TLD";
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
