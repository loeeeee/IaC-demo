{ config, pkgs, lib, ... }:

{
  # Configure dufs user and group with UID/GID 2343 (mapped from host 102343)
  users.groups.dufs = {
    gid = lib.mkForce 2343;
  };
  
  users.users.dufs = {
    isSystemUser = true;
    uid = lib.mkForce 2343;
    group = "dufs";
    home = "/var/lib/dufs";
    createHome = true;
  };

  # Create necessary directories and symlink
  systemd.tmpfiles.rules = [
    "d /var/lib/dufs 0755 dufs dufs -"
    "d /var/lib/dufs/share 0755 dufs dufs -"
    "L+ /var/lib/dufs/share/loe - - - - /mnt/Share-loe"
  ];

  environment.systemPackages = with pkgs; [
    dufs
  ];

  # Create wrapper script for dufs with proper argument handling
  systemd.services.dufs = {
    description = "Dufs file server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      User = "dufs";
      Group = "dufs";
      ExecStart = pkgs.writeShellScript "dufs-wrapper" ''
        exec ${pkgs.dufs}/bin/dufs \
          --bind 0.0.0.0 \
          --port 8080 \
          --allow-upload \
          --allow-delete \
          --allow-search \
          --allow-archive \
          --allow-symlink \
          --auth 'loe:$6$lmOrNI.DgGz9.rbz$uGU3kW3lgRYf/G1UazWzWoHed3kdnSrFAup7E3RFTQbHLNWzHkhZL8skUeBDJCd5FJCMlfReYcWGdctPp6OkU.@/:rw' \
          /var/lib/dufs/share
      '';
      Restart = "on-failure";
      RestartSec = "10s";
      
      # Security settings
      NoNewPrivileges = true;
      PrivateTmp = false;
      ProtectSystem = "no";  # Allow write access to mount point
      ProtectHome = true;
      ReadWritePaths = [
        "/var/lib/dufs"
        "/var/lib/dufs/share"
      ];
    };
  };
}

