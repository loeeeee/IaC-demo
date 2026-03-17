{ config, pkgs, lib, ... }:

{
  # Configure DNS servers - BIND will be authoritative for home.REDACTED-DOMAIN.TLD
  networking.nameservers = [ "172.21.0.1" ];

  systemd.services.bind = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
  
  services.bind = {
    enable = true;

    ipv4Only = true;
    
    package = pkgs.bind.overrideAttrs (oldAttrs: {
      # Change pkgs.json-c to pkgs.json_c
      buildInputs = (oldAttrs.buildInputs or []) ++ [ pkgs.json_c ]; 
      configureFlags = (oldAttrs.configureFlags or []) ++ [ "--with-json-c" ];
    });
    
    # TSIG key for secure DDNS communication with KEA DHCP
    # This key will be shared with KEA configuration
    # Algorithm: HMAC-SHA256
    # Key name: kea-ddns-key
    # Generate with: tsig-keygen -a hmac-sha256 kea-ddns-key
    # Or generate secret with: openssl rand -base64 32
    # Note: In production, consider using NixOS secrets management
    extraConfig = ''
      # Statistics Channel for Prometheus Exporter
      statistics-channels {
        inet 127.0.0.1 port 8053 allow { 127.0.0.1; };
      };

      include "/etc/secret/keys.conf";
    '';

    # Zone configuration
    zones = {
      # Forward zone for home.REDACTED-DOMAIN.TLD
      "home.REDACTED-DOMAIN.TLD" = {
        master = true;
        file = "/var/lib/bind/home.REDACTED-DOMAIN.TLD.zone";
        extraConfig = ''
          allow-update { 
            key "kea-ddns-key";
            key "pfsense-ddns-key";
          };
        '';
      };

      # Reverse zone for 172.21.0.0/16 network
      "21.172.in-addr.arpa" = {
        master = true;
        file = "/var/lib/bind/21.172.in-addr.arpa.zone";
        extraConfig = ''
          allow-update { 
            key "kea-ddns-key";
            key "pfsense-ddns-key";
          };
        '';
      };
    };

    # Cache configuration
    cacheNetworks = [
      "127.0.0.0/8"
      "172.21.0.0/16"
      "10.0.0.0/8"
      "192.168.0.0/16"
    ];

    # Listen on all interfaces, cannot be 0.0.0.0
    listenOn = [ "172.21.0.128" "127.0.0.1" ];

    # Forward queries for external domains
    forwarders = [
      "172.21.0.1"  # PFSense DNS
    ];

    # Additional options
    extraOptions = ''
      // Allow queries from private networks
      allow-query { 
        127.0.0.0/8;
        172.21.0.0/16;
        10.0.0.0/8;
        192.168.0.0/16;
      };

      // Allow recursive queries from private networks
      allow-recursion {
        127.0.0.0/8;
        172.21.0.0/16;
        10.0.0.0/8;
        192.168.0.0/16;
      };

      // Security options
      version none;
      hostname none;
    '';
  };

  # Create log directory for BIND
  systemd.tmpfiles.rules = [
    "d /var/lib/bind 0750 named named -"
    "d /var/log/named 0750 named named -"
  ];

  # Initial zone file for home.REDACTED-DOMAIN.TLD
  systemd.services.bind-zone-init = {
    description = "Initialize BIND zone files";
    wantedBy = [ "multi-user.target" ];
    before = [ "bind.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ZONE_DIR="/var/lib/bind"
      
      # Create forward zone file if it doesn't exist
      if [ ! -f "$ZONE_DIR/home.REDACTED-DOMAIN.TLD.zone" ]; then
        cat > "$ZONE_DIR/home.REDACTED-DOMAIN.TLD.zone" <<'EOF'
$TTL 3600
@       IN SOA  ota.home.REDACTED-DOMAIN.TLD. admin.home.REDACTED-DOMAIN.TLD. (
                2025010101  ; Serial
                3600        ; Refresh
                1800        ; Retry
                604800      ; Expire
                86400       ; Minimum TTL
                )
;NAMESERVERS
@       IN NS   ota.home.REDACTED-DOMAIN.TLD.

;RECORDS
ota     IN A    172.21.0.128

;WILDCARD
$ORIGIN home.REDACTED-DOMAIN.TLD.
*       IN CNAME home.REDACTED-DOMAIN.TLD.
EOF
        chown named:named "$ZONE_DIR/home.REDACTED-DOMAIN.TLD.zone"
        chmod 644 "$ZONE_DIR/home.REDACTED-DOMAIN.TLD.zone"
      fi

      # Create reverse zone file if it doesn't exist
      if [ ! -f "$ZONE_DIR/21.172.in-addr.arpa.zone" ]; then
        cat > "$ZONE_DIR/21.172.in-addr.arpa.zone" <<'EOF'
$TTL 3600
@       IN SOA  ota.home.REDACTED-DOMAIN.TLD. admin.home.REDACTED-DOMAIN.TLD. (
                2025010101  ; Serial
                3600        ; Refresh
                1800        ; Retry
                604800      ; Expire
                86400       ; Minimum TTL
                )
@       IN NS   ota.home.REDACTED-DOMAIN.TLD.
128.0   IN PTR  ota.home.REDACTED-DOMAIN.TLD.
EOF
        chown named:named "$ZONE_DIR/21.172.in-addr.arpa.zone"
        chmod 644 "$ZONE_DIR/21.172.in-addr.arpa.zone"
      fi
    '';
  };
}

