{ config, pkgs, lib, ... }:

{
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
    
    extraConfig = ''
      # Statistics Channel for Prometheus Exporter
      statistics-channels {
        inet 127.0.0.1 port 8053 allow { 127.0.0.1; };
      };
    '';

    # Zone configuration
    zones = {
      # Forward zone for wilmington.REDACTED-DOMAIN.TLD
      "wilmington.REDACTED-DOMAIN.TLD" = {
        master = true;
        file = "/var/lib/bind/wilmington.REDACTED-DOMAIN.TLD.zone";
      };

      # Reverse zone for 172.22.0.0/16 network
      "23.172.in-addr.arpa" = {
        master = true;
        file = "/var/lib/bind/23.172.in-addr.arpa.zone";
      };
    };

    # Cache configuration
    cacheNetworks = [
      "127.0.0.0/8"
      "172.23.0.0/16"
      "10.0.0.0/8"
      "192.168.0.0/16"
    ];

    # Listen on all interfaces, cannot be 0.0.0.0
    listenOn = [ "172.23.0.2" "127.0.0.1" ];

    # Forward queries for external domains
    forwarders = [
      "185.12.64.1"
      "185.12.64.2"
    ];

    # Additional options
    extraOptions = ''
      // Allow queries from private networks
      allow-query { 
        127.0.0.0/8;
        172.23.0.0/16;
        172.22.0.0/16;
        10.0.0.0/8;
        192.168.0.0/16;
      };

      // Allow recursive queries from private networks
      allow-recursion {
        127.0.0.0/8;
        172.23.0.0/16;
        172.22.0.0/16;
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

  # Initial zone file for wilmington.REDACTED-DOMAIN.TLD
  systemd.services.bind-zone-init = {
    description = "Initialize BIND zone files";
    wantedBy = [ "multi-user.target" ];
    before = [ "bind.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ZONE_DIR="/var/lib/bind"
      
      # Create forward zone file if it doesn't exist
      if [ ! -f "$ZONE_DIR/wilmington.REDACTED-DOMAIN.TLD.zone" ]; then
        cat > "$ZONE_DIR/wilmington.REDACTED-DOMAIN.TLD.zone" <<'EOF'
$TTL 3600
@       IN SOA  tuff.wilmington.REDACTED-DOMAIN.TLD. admin.wilmington.REDACTED-DOMAIN.TLD. (
                2025010101  ; Serial
                3600        ; Refresh
                1800        ; Retry
                604800      ; Expire
                86400       ; Minimum TTL
                )
;NAMESERVERS
@       IN NS   tuff.wilmington.REDACTED-DOMAIN.TLD.

;RECORDS
tuff  IN A    172.23.0.2

;Wilmington Public IP
@       IN A    REDACTED

;WILDCARD
$ORIGIN wilmington.REDACTED-DOMAIN.TLD.
*       IN CNAME wilmington.REDACTED-DOMAIN.TLD.
EOF
        chown named:named "$ZONE_DIR/wilmington.REDACTED-DOMAIN.TLD.zone"
        chmod 644 "$ZONE_DIR/wilmington.REDACTED-DOMAIN.TLD.zone"
      fi

      # Create reverse zone file if it doesn't exist
      if [ ! -f "$ZONE_DIR/23.172.in-addr.arpa.zone" ]; then
        cat > "$ZONE_DIR/23.172.in-addr.arpa.zone" <<'EOF'
$TTL 3600
@       IN SOA  tuff.wilmington.REDACTED-DOMAIN.TLD. admin.wilmington.REDACTED-DOMAIN.TLD. (
                2025010101  ; Serial
                3600        ; Refresh
                1800        ; Retry
                604800      ; Expire
                86400       ; Minimum TTL
                )
@       IN NS   tuff.wilmington.REDACTED-DOMAIN.TLD.
2.0   IN PTR  tuff.wilmington.REDACTED-DOMAIN.TLD.
EOF
        chown named:named "$ZONE_DIR/23.172.in-addr.arpa.zone"
        chmod 644 "$ZONE_DIR/23.172.in-addr.arpa.zone"
      fi
    '';
  };
}
