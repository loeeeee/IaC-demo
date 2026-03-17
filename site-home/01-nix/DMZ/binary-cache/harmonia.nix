{ config, pkgs, ... }:

{
  services.harmonia = {
    enable = true;
    
    settings = {
      # Listen on all interfaces for binary cache access
      bind = "0.0.0.0:5000";
      
      # Signing key configuration
      # Note: Keys should be generated with:
      # nix-store --generate-binary-cache-key sapporo /var/lib/harmonia/cache-priv-key.pem /var/lib/harmonia/cache-pub-key.pem
      sign_key_paths = [ "/var/lib/harmonia/cache-priv-key.pem" ];
      
      # Virtual Nix store path should match the real store
      virtual_nix_store = "/nix/store";
      
      # Real Nix store path
      real_nix_store = "/nix/store";
    };
  };

  # Create harmonia user and directories
  users.users.harmonia = {
    isSystemUser = true;
    group = "harmonia";
    home = "/var/lib/harmonia";
    createHome = true;
  };

  users.groups.harmonia = {};

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /var/lib/harmonia 0755 harmonia harmonia -"
    "d /var/cache/harmonia 0755 harmonia harmonia -"
  ];
}
