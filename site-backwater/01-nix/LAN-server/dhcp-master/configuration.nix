{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./custom-modules/_init_.nix
    ./hostname.nix
    ./networking.nix
    # Applications
    ./kea-dhcp4.nix
    ./kea-dhcp-ddns.nix
    ./prometheus-exporter.nix
  ];

  boot.isContainer = true;

  proxmoxLXC.manageNetwork = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
  ];

  environment.systemPackages = with pkgs; [
    git
    curl
    htop
  ];

  networking.firewall.enable = false;
  networking.nftables = {
    enable = true;
    flushRuleset = true;
    rulesetFile = ./nftables.nft;
  };

  services.timesyncd.enable = true;

  system.stateVersion = "25.05";

  time.timeZone = "America/Chicago";

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
}

