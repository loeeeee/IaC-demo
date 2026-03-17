{ config, pkgs, lib, modulesPath, ... }:

{
  # Configure user loe
  # UID/GID must match host filesystem (102340) for virtiofs mounts
  # Host UID 102340 maps to container UID 2340 in LXC, but virtiofs passes through host UIDs directly
  users.groups.loe = {
    gid = 102340;
  };
  users.users.loe = {
    isNormalUser = true;
    uid = 102340;
    group = "loe";
    home = "/home/loe";
    createHome = true;
    extraGroups = [ "render" "video" "input" "audio" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 REDACTED REDACTED@REDACTED"
      "ssh-ed25519 REDACTED REDACTED@REDACTED"
    ];
    hashedPassword = "REDACTED";
    linger = true;
  };
}
