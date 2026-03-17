{ config, pkgs, modulesPath, lib, ... }:

{
  # Configure user victorialogs
  users.groups.victorialogs = {
    gid = lib.mkForce 2352;
  };
  users.users.victorialogs = {
    isSystemUser = true;
    uid = lib.mkForce 2352;
    group = "victorialogs";
    home = lib.mkDefault "/var/lib/victorialogs";
    createHome = true;
  };

  # VictoriaLogs service
  services.victorialogs = {
    enable = true;
    stateDir = "victorialogs";
    listenAddress = "0.0.0.0:9428";
    extraOptions = [ 
      "-syslog.listenAddr.tcp=:5514"
      "-syslog.listenAddr.udp=:5514"
    ];
  };

  # Override systemd service to use static user instead of DynamicUser
  # This is necessary because we have a mount point at /var/lib/victorialogs
  # and need to use the specific UID/GID 2352
  systemd.services.victorialogs = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = lib.mkForce "victorialogs";
      Group = lib.mkForce "victorialogs";
      StateDirectory = lib.mkForce "";  # Disable StateDirectory since we use mount point
    };
  };
}

