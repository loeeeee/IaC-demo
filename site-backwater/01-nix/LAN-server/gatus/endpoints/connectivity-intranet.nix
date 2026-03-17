# Internal Connectivity Endpoints
# ICMP ping checks to verify intranet connectivity from backwater infrastructure
[
  # ============================================
  # Home Site Connectivity (via WireGuard tunnel)
  # Network: 172.21.0.0/16
  # ============================================
  {
    name = "home-pfsense";
    group = "intranet connectivity";
    url = "tcp://172.21.0.1:8443";
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
    name = "home-proxmox";
    group = "intranet connectivity";
    url = "tcp://172.21.0.10:8006";
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
  # Wilmington Site Connectivity (via WireGuard tunnel)
  # Network: 172.23.0.0/16
  # ============================================
  {
    name = "wilmington-tuff";
    group = "intranet connectivity";
    url = "tcp://172.23.0.2:443";
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
]
