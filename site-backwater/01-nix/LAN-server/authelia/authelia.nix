{ config, pkgs, lib, ... }:

let
  # Generate RSA key pair for OIDC at build time
  oidcKeyGen = pkgs.runCommand "authelia-oidc-keys" {} ''
    mkdir -p $out
    ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 \
      -keyout $out/oidc-private-key.pem \
      -out $out/oidc-certificate.pem \
      -days 3650 -nodes \
      -subj "/CN=auth.backwater.REDACTED-DOMAIN.TLD/O=Authelia/C=US"
  '';

  # Read the generated keys
  oidcPrivateKey = builtins.readFile "${oidcKeyGen}/oidc-private-key.pem";
  oidcCertificate = builtins.readFile "${oidcKeyGen}/oidc-certificate.pem";

  # Generate HMAC secret at build time (32 bytes, base64 encoded)
  hmacSecretGen = pkgs.runCommand "authelia-hmac-secret" {} ''
    ${pkgs.openssl}/bin/openssl rand -base64 32 > $out
  '';
  hmacSecret = lib.removeSuffix "\n" (builtins.readFile hmacSecretGen);
in
{
  # Configure authelia user and group (no bind-mount; allow system-assigned IDs)
  users.groups.authelia = { };
  users.users.authelia = {
    isSystemUser = true;
    group = "authelia";
    home = lib.mkDefault "/var/lib/authelia";
    createHome = true;
  };

  services.authelia.instances.main = {
    enable = true;
    user = "authelia";
    group = "authelia";

    secrets = {
      jwtSecretFile = "/etc/secret/jwt-secret";
      sessionSecretFile = "/etc/secret/session-secret";
      storageEncryptionKeyFile = "/etc/secret/storage-encryption-key";
    };

    environmentVariables = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = "/etc/secret/lldap-password";
    };

    settings = {
      theme = "dark";

      # Server configuration
      server = {
        address = "tcp://:8080/";
      };

      # Logging
      log = {
        level = "info";
        format = "text";
      };

      # TOTP configuration
      totp = {
        issuer = "backwater.REDACTED-DOMAIN.TLD";
        period = 30;
        digits = 6;
      };

      # Authentication backend - LLDAP
      authentication_backend = {
        password_reset.disable = false;
        ldap = {
          implementation = "lldap";
          address = "ldap://172.22.0.115:3890";
          base_dn = "dc=backwater,dc=REDACTED-DOMAIN,dc=TLD";
          user = "uid=service_authelia,ou=people,dc=backwater,dc=REDACTED-DOMAIN,dc=TLD";
          users_filter = "(&(|({username_attribute}={input})({mail_attribute}={input}))(objectClass=person))";
          groups_filter = "(member={dn})";
          attributes = {
            username = "uid";
            display_name = "cn";
            mail = "mail";
            group_name = "cn";
          };
        };
      };

      # Access control configuration
      access_control = {
        default_policy = "deny";
        rules = [
          # Bypass auth portal itself
          {
            domain = "auth.backwater.REDACTED-DOMAIN.TLD";
            policy = "bypass";
          }
          # Restrict code-server to user loe (one factor)
          {
            domain = "code.backwater.REDACTED-DOMAIN.TLD";
            policy = "one_factor";
            subject = [
              "user:loe"
              "user:lbi"
            ];
          }
          # Explicitly deny all other users for code-server
          {
            domain = "code.backwater.REDACTED-DOMAIN.TLD";
            policy = "deny";
          }
          # qbittorrent - only user loe may access
          {
            domain = "downloader.backwater.REDACTED-DOMAIN.TLD";
            policy = "one_factor";
            subject = [
              "user:loe"
              "user:lbi"
            ];
          }
          # Explicitly deny all other users for qbittorrent
          {
            domain = "downloader.backwater.REDACTED-DOMAIN.TLD";
            policy = "deny";
          }
          # Restrict gatus to user loe (one factor)
          {
            domain = "status.backwater.REDACTED-DOMAIN.TLD";
            policy = "one_factor";
            subject = [
              "user:loe"
              "user:lbi"
            ];
          }
          # Explicitly deny all other users for gatus
          {
            domain = "status.backwater.REDACTED-DOMAIN.TLD";
            policy = "deny";
          }
          # Restrict claw to user loe (one factor)
          {
            domain = "claw.backwater.REDACTED-DOMAIN.TLD";
            policy = "one_factor";
            subject = [
              "user:loe"
              "user:lbi"
            ];
          }
          # Explicitly deny all other users for claw
          {
            domain = "claw.backwater.REDACTED-DOMAIN.TLD";
            policy = "deny";
          }
          # Default rule for all other domains - require one factor
          {
            domain = "*.backwater.REDACTED-DOMAIN.TLD";
            policy = "one_factor";
          }
        ];
      };

      # Session configuration
      session = {
        cookies = [
          {
            domain = "backwater.REDACTED-DOMAIN.TLD";
            authelia_url = "https://auth.backwater.REDACTED-DOMAIN.TLD";
            default_redirection_url = "https://backwater.REDACTED-DOMAIN.TLD";
          }
        ];
        expiration = "1h";
        inactivity = "5m";
        remember_me = "1M";
      };

      # Regulation to prevent brute-force
      regulation = {
        max_retries = 3;
        find_time = "2m";
        ban_time = "5m";
      };

      # Storage configuration - PostgreSQL (inline password per request)
      storage = {
        postgres = {
          address = "tcp://172.22.0.133:5432";
          database = "authelia";
          username = "authelia";
          password = "REDACTED";
          # tls block omitted to use plain TCP; avoids deprecated ssl options
        };
      };

      # Notifier configuration - disable startup check and write to a sink to avoid RO mount issues
      notifier = {
        disable_startup_check = true;
        filesystem = {
          filename = "/dev/null";
        };
      };

      # OIDC Identity Provider configuration
      identity_providers = {
        oidc = {
          hmac_secret = hmacSecret;
          # Lifespan configuration - using deprecated keys as newer format not yet supported
          # TODO: Update when Authelia module supports new lifespan format
          access_token_lifespan = "1h";
          authorize_code_lifespan = "1m";
          jwks = [
            {
              key_id = "authelia";
              algorithm = "RS256";
              use = "sig";
              certificate_chain = oidcCertificate;
              key = oidcPrivateKey;
            }
          ];
          clients = [
            {
              client_id = "immich";
              client_name = "immich";
              client_secret = builtins.readFile "/etc/secret/immich.txt";
              public = false;
              authorization_policy = "one_factor";
              require_pkce = false;
              redirect_uris = [
                "https://photos.backwater.REDACTED-DOMAIN.TLD/auth/login"
                "https://photos.backwater.REDACTED-DOMAIN.TLD/user-settings"
                "app.immich:///oauth-callback"
              ];
              scopes = [ "openid" "profile" "email" ];
              response_types = [ "code" ];
              grant_types = [ "authorization_code" ];
              access_token_signed_response_alg = "none";
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "client_secret_post";
            }
          ];
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /etc/secret/ 0700 authelia authelia -"
  ];

  # Override systemd service to use static user instead of DynamicUser
  # This is needed because /var/lib/authelia is a mount point from Proxmox
  # Note: service name is authelia-main because instance is named "main"
  systemd.services.authelia-main = {
    serviceConfig = {
      DynamicUser = lib.mkForce true;
      User = "authelia";
      Group = "authelia";
      StateDirectory = lib.mkForce "";
      StateDirectoryMode = lib.mkForce "";
    };
  };
}

