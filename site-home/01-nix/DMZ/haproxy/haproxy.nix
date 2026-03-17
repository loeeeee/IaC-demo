{ config, pkgs, lib, ... }:

let
  # Domain for certificates
  domain = "home.REDACTED-DOMAIN.TLD";
  certDir = config.security.acme.certs."${domain}".directory;

  # Lua path for Authelia forward-auth scripts
  luaPath = "/etc/haproxy/lua";

  # Read and substitute the HAProxy config template
  haproxyConfigTemplate = builtins.readFile ./haproxy.cfg;
  haproxyConfig = builtins.replaceStrings
    [ "@CERT_DIR@" "@LUA_PATH@" ]
    [ certDir luaPath ]
    haproxyConfigTemplate;

  haproxyLuaHttp = pkgs.fetchFromGitHub {
    owner = "haproxytech";
    repo = "haproxy-lua-http";
    rev = "master";
    sha256 = "sha256-ooHq9ORqJcu4EPFVOMtyPC5uk05adkysfm2VhiAJUtY=";
  };

  autheliaAuthRequest = pkgs.fetchFromGitHub {
    owner = "TimWolla";
    repo = "haproxy-auth-request";
    rev = "master";
    sha256 = "sha256-9XZKCTNiN5tUUxkRHfQxUs85lGLCuUyt4ix0bMu55fg=";
  };

  luaJson = pkgs.fetchFromGitHub {
    owner = "rxi";
    repo = "json.lua";
    rev = "v0.1.2";
    sha256 = "sha256-JSKMxF5NSHW3QaELFPWm1sx7kHmOXEPsUkM3i/px7Gk=";
  };
in
{
  # ACME configuration for Let's Encrypt wildcard certificate
  security.acme = {
    acceptTerms = true;
    defaults.email = "REDACTED@REDACTED";

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

  services.haproxy = {
    enable = true;
    config = haproxyConfig;
  };

  users.users.haproxy.extraGroups = [ "acme" ];

  systemd.tmpfiles.rules = [
    "d /run/haproxy 0755 haproxy haproxy -"
    "d ${luaPath} 0755 haproxy haproxy -"
    "d ${luaPath}/haproxy-lua-http 0755 haproxy haproxy -"
    "L+ ${luaPath}/haproxy-lua-http/http.lua - - - - ${haproxyLuaHttp}/http.lua"
    "L+ ${luaPath}/auth-request.lua - - - - ${autheliaAuthRequest}/auth-request.lua"
    "L+ ${luaPath}/json.lua - - - - ${luaJson}/json.lua"
    # Keep site-home specific settings
    "d /var/lib/haproxy 0755 haproxy haproxy -"
    "f /var/lib/haproxy/server_state 0644 haproxy haproxy -"
  ];

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
    after = [ "acme-${domain}.service" "haproxy-default-page.service" ];
    wants = [ "acme-${domain}.service" "haproxy-default-page.service" ];
  };

  # Don't auto-start ACME services during nixos-rebuild switch
  # Run manually first time: systemctl start acme-home.REDACTED-DOMAIN.TLD.service
  systemd.services."acme-${domain}" = {
    wantedBy = lib.mkForce [];
  };
  systemd.services."acme-order-renew-${domain}" = {
    wantedBy = lib.mkForce [];
  };
}

