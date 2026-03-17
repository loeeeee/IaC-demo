{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # System
      ./hostname.nix
      # Applications
    ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  services.qemuGuest.enable = true;

  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" ];
  boot.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    wget
    curl
    btop
    git
    htop
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
  ];

  networking.firewall.enable = false;
  networking.nftables = {
    enable = true;
    flushRuleset = true;
    rulesetFile = ./nftables.nft;
  };

  system.copySystemConfiguration = true;

  # DO NOT CHANGE
  system.stateVersion = "25.11"; # Did you read the comment?
}