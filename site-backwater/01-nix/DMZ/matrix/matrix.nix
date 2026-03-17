{ config, pkgs, lib, ... }:

{
  services.matrix-tuwunel = {
    enable = true;
    user = "matrix";
    group = "matrix";
    stateDirectory = "matrix";
    settings.global = {
      server_name = "matrix.backwater.REDACTED-DOMAIN.TLD";
      port = [
        8080
      ];
      address = [
        "172.22.100.117"
      ];
      allow_registration = false;
      allow_federation = true;
      trusted_servers = [];
    };
  };

  users.groups.matrix = {
    gid = 2358;
  };

  users.users.matrix = {
    isSystemUser = true;
    home = "/var/lib/matrix";
    createHome = true;
    uid = 2358;
    group = "matrix";
  };

  # Ensure the secret directory exists
  systemd.tmpfiles.rules = [
    "d /etc/secret 0700 root root -"
  ];
}
