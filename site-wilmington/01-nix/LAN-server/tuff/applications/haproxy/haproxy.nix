{ config, pkgs, lib, ... }:

let
  # Domain for certificates
  domain = "wilmington.REDACTED-DOMAIN.TLD";
  certDir = config.security.acme.certs."${domain}".directory;

  # Read and substitute the HAProxy config template
  haproxyConfigTemplate = builtins.readFile ./haproxy.cfg;
  haproxyConfig = builtins.replaceStrings
    [ "@CERT_DIR@" "@DOMAIN@" ]
    [ certDir domain ]
    haproxyConfigTemplate;
in
{
  # ACME configuration for Let's Encrypt wildcard certificate
  security.acme = {
    acceptTerms = true;
    defaults.email = "REDACTED@REDACTED-DOMAIN.TLD";

    certs."${domain}" = {
      domain = "*.${domain}";
      extraDomainNames = [ domain ];
      dnsProvider = "porkbun";
      environmentFile = "/etc/secret/acme-porkbun-env";
      # Use public DNS resolver for propagation check (avoids local DNS cache issues)
      dnsResolver = "1.1.1.1:53";
      # Skip local propagation check - let Let's Encrypt verify directly
      # (Porkbun DNS can be slow to propagate to external resolvers)
      dnsPropagationCheck = false;
      # Reload HAProxy when certificate is renewed
      reloadServices = [ "haproxy" ];
    };
  };

  # HAProxy service
  services.haproxy = {
    enable = true;
    config = haproxyConfig;
  };

  # Ensure HAProxy can read the certificates
  users.users.haproxy.extraGroups = [ "acme" ];

  # Create runtime directory for HAProxy socket and Lua scripts
  systemd.tmpfiles.rules = [
    "d /run/haproxy 0755 haproxy haproxy -"
  ];

  # Create default page for HAProxy
  systemd.services.haproxy-default-page = {
    description = "Create default page for HAProxy";
    wantedBy = [ "multi-user.target" ];
    before = [ "haproxy.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    restartIfChanged = true;

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      # Ensure directory exists
      mkdir -p /run/haproxy
      chown haproxy:haproxy /run/haproxy
      chmod 755 /run/haproxy

      # Create the HTTP response file with headers
      {
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: text/html; charset=utf-8"
        echo "Cache-Control: no-cache"
        echo "Connection: close"
        echo ""
        cat ${./haproxy-default.html}
      } > /run/haproxy/default.http

      chmod 644 /run/haproxy/default.http
      chown haproxy:haproxy /run/haproxy/default.http
    '';
  };

  # Ensure certificate directory exists before HAProxy starts
  systemd.services.haproxy = {
    after = [ "acme-${domain}.service" ];
    wants = [ "acme-${domain}.service" ];
  };

  # Don't auto-start ACME services during nixos-rebuild switch
  # Run manually first time: systemctl start acme-backwater.REDACTED-DOMAIN.TLD.service
  systemd.services."acme-${domain}" = {
    wantedBy = lib.mkForce [];
  };
  systemd.services."acme-order-renew-${domain}" = {
    wantedBy = lib.mkForce [];
  };
}

