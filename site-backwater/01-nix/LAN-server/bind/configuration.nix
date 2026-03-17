{ config, pkgs, modulesPath, ... }:

{
  imports = [
    # Use the Proxmox-specific module for better compatibility
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    # Do not use binary cache, DNS will cause deadlock
    ./custom-modules/remote-builder.nix
    ./custom-modules/logging.nix
    ./custom-modules/nix-features.nix
    ./hostname.nix
    # Applilcations 
    ./bind.nix
    ./prometheus-exporter.nix
  ];
  boot.isContainer = true;

  # Defer network management to Proxmox VE to prevent conflicts
  proxmoxLXC.manageNetwork = true;

  # Configure network interface with DHCP
  networking.interfaces.eth0.useDHCP = true;

  # Enable OpenSSH server with pubkey-only authentication
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # Configure root user with SSH key-only authentication
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
    "ssh-ed25519 REDACTED REDACTED@REDACTED"
  ];

  # Minimal system packages (bind provides nsupdate for one-time DDNS updates)
  environment.systemPackages = with pkgs; [
    bind
  ];

  # Enable nftables and firewall
  networking.firewall.enable = false;
  networking.nftables = {
    enable = true;
    flushRuleset = true;
    rulesetFile = ./nftables.nft;
  };

  # Disable unnecessary services
  services.timesyncd.enable = true;  # For time synchronization

  # System state version
  system.stateVersion = "25.05";  # Adjust based on NixOS version

  time.timeZone = "America/Chicago";
}
