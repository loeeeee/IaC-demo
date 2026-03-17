{ config, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./hostname.nix
    ./haproxy.nix
  ];

  boot.isContainer = true;
  proxmoxLXC.manageNetwork = true;

  networking.interfaces.eth0.useDHCP = true;
  networking.nameservers = [ "172.21.1.1" ];

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

  system.stateVersion = "25.11";
  time.timeZone = "Asia/Shanghai";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
}

