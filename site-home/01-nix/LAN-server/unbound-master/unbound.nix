{ config, pkgs, ... }:

{
  services.unbound = {
    enable = true;

    settings = {
      server = {
        # Keepalived needs this
        interface-automatic = "yes";

        # Listen on all available network interfaces
        interface = [ "0.0.0.0" "::" ];

        # Grant query permissions to private network ranges
        access-control = [
          "127.0.0.0/8 allow"
          "10.0.0.0/8 allow"
          "172.16.0.0/12 allow"
          "192.168.0.0/16 allow"
          "::1/128 allow"
          "fc00::/7 allow"
          "fe80::/10 allow"
        ];

        # Prevent Unbound from sanitizing private IPs 
        # returned by BIND. Without this, Unbound will return NXDOMAIN 
        # for your local servers to protect against DNS Rebinding attacks.
        private-domain = [ 
          "home.REDACTED-DOMAIN.TLD"
          "21.172.in-addr.arpa"
        ];
        
        # Skip validation for internal domain if DNSSEC is not setup.
        domain-insecure = [
          "home.REDACTED-DOMAIN.TLD"
          "21.172.in-addr.arpa"
        ];

        auto-trust-anchor-file = "/var/lib/unbound/root.key";

        # Security Hardening
        hide-identity = "yes";
        hide-version = "yes";
        harden-glue = "yes";
        harden-dnssec-stripped = "yes";

        # Performance Tuning
        num-threads = 2;
        msg-cache-size = "64m";
        rrset-cache-size = "128m";
        so-reuseport = true;
        prefetch = true;
        
      };

      # Forward Zone vs Stub Zone:
      # 'stub-zone' works best when connecting to an authoritative server (BIND).
      # It instructs Unbound to use the specific NS records.
      stub-zone = [
        {
          name = "home.REDACTED-DOMAIN.TLD.";
          stub-addr = "172.21.0.128"; # IP of BIND server
        }
        {
          name = "21.172.in-addr.arpa.";
          stub-addr = "172.21.0.128"; # IP of BIND server
        }
        {
          name = "backwater.REDACTED-DOMAIN.TLD.";
          stub-addr = "172.22.0.110"; # IP of your BIND server
        }
        {
          name = "22.172.in-addr.arpa.";
          stub-addr = "172.22.0.110"; # IP of your BIND server
        }
        # {
        #   name = "wilmington.REDACTED-DOMAIN.TLD.";
        #   stub-addr = "172.23.0.2"; # IP of your BIND server
        # }
        # {
        #   name = "23.172.in-addr.arpa.";
        #   stub-addr = "172.23.0.2"; # IP of your BIND server
        # }
      ];

      # Forward zones for specific domains
      forward-zone = import ./unbound-forward-zone.nix;

      # Enable remote-control for the unbound-control command
      remote-control = {
        control-enable = true;
      };
    };
  };
}

