{ config, pkgs, modulesPath, ... }:

{  
  nixpkgs.config.allowUnfree = true;

  # Configure user loe
  users.groups.jellyfin = {
    gid=2347;
  };
  users.users.jellyfin = {
    isSystemUser = true;
    uid = 2347;
    group = "jellyfin";
    home = "/var/lib/jellyfin";
    createHome = true;
    extraGroups = [ "render" "video" ];
  };

  services.jellyfin.enable = true;
}
