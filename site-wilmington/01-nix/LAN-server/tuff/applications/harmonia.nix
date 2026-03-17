{ config, pkgs, ... }:

{
  services.harmonia = {
    enable = true;
    signKeyPaths = [ "/var/lib/harmonia/cache-priv-key.pem" ];

    settings = {
      bind = "127.0.0.1:5000";

      # Signing key configuration
      # Note: Keys should be generated with:
      # nix-store --generate-binary-cache-key mirach /var/lib/harmonia/cache-priv-key.pem /var/lib/harmonia/cache-pub-key.pem

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
