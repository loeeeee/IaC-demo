# Authentication Services Endpoints
# Network: LAN-server (172.22.0.0/24)
[
  {
    name = "lldap-http";
    group = "auth";
    url = "http://172.22.0.115:8080";
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
    name = "lldap-ldap";
    group = "auth";
    url = "tcp://172.22.0.115:3890";
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
    name = "authelia";
    group = "auth";
    url = "http://172.22.0.116:8080";
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
