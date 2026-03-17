{ config, pkgs, lib, ... }:

{
  # Configure lldap user and group (let system allocate IDs)
  users.groups.lldap = { };
  users.users.lldap = {
    isSystemUser = true;
    group = "lldap";
    home = lib.mkDefault "/var/lib/lldap";
    createHome = true;
  };

  services.lldap = {
    enable = true;

    settings = {
      # LDAP server settings
      ldap_host = "0.0.0.0";
      ldap_port = 3890;

      # Web UI settings
      http_host = "0.0.0.0";
      http_port = 8080;
      http_url = "http://localhost:8080";

      # Base DN for LDAP
      ldap_base_dn = "dc=backwater,dc=REDACTED-DOMAIN,dc=TLD";

      # Admin user
      ldap_user_dn = "REDACTED";
      ldap_user_email = "REDACTED@backwater.REDACTED-DOMAIN.TLD";

      # Admin password file (required by NixOS module)
      ldap_user_pass = "REDACTED";

      # Database backend (password provided via environment file)
      database_url = "postgresql://lldap:REDACTED@172.22.0.133:5432/lldap";

      jwt_secret_file = "/etc/secret/jwt";

      # Verbose logging for debugging (can be disabled later)
      verbose = false;
    };
  };

  # Use a static service user to keep stable ownership even without host bind-mounts
  systemd.services.lldap = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "lldap";
      Group = "lldap";
      StateDirectory = lib.mkForce "";
      StateDirectoryMode = lib.mkForce "";
    };
  };

  # Ensure secret directory exists for admin password and DB env file
  systemd.tmpfiles.rules = [
    "d /etc/secret 0700 lldap lldap -"
  ];
}

