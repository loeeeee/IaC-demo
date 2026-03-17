{ config, pkgs, lib, ... }:

{
  # Immich Machine Learning server with ROCm GPU acceleration
  # Database: PostgreSQL at alkaid/172.22.0.133
  # Redis: alnair/172.22.0.140:6380
  # Access: Behind HAProxy on port 3003

  # Create immich user and group with GPU access
  users.groups.immich = {
    gid = 2342;
  };

  users.users.immich = {
    isSystemUser = true;
    group = "immich";
    uid = 2342;
    description = "Immich machine learning service user";
    home = "/var/lib/immich";
    createHome = true;
    extraGroups = [ "render" "video" ]; # GPU device access
  };

  # Ensure directories exist with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/immich 0755 immich immich -"
    "d /var/lib/immich/.config 0755 immich immich -"
    "d /var/lib/immich/.config/miopen 0755 immich immich -"
    "d /var/cache/immich 0755 immich immich -"
  ];

  # Install immich-machine-learning package
  environment.systemPackages = with pkgs; [
    immich-machine-learning
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     onnxruntime = prev.onnxruntime.override {
  #       rocmSupport = true;
  #     };
  #   })
  # ];


  # Configure Immich Machine Learning service as systemd service
  systemd.services.immich-machine-learning = {
    description = "Immich Machine Learning service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      User = "immich";
      Group = "immich";
      ExecStart = lib.getExe pkgs.immich-machine-learning;
      Restart = "on-failure";
      RestartSec = "10s";

      # Security settings
      NoNewPrivileges = true;
      PrivateTmp = false;
      ProtectSystem = "no";
      ProtectHome = true;
      ReadWritePaths = [
        "/var/lib/immich"
        "/var/lib/immich/.config"
        "/var/cache/immich"
      ];
    };

    environment = {
      # ROCm paths for GPU acceleration
      ROCM_PATH = "${pkgs.rocmPackages.clr}";
      CPATH = "${pkgs.rocmPackages.rocrand}/include:${pkgs.rocmPackages.rocblas}/include:${pkgs.rocmPackages.clr}/include";
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";

      # MIOpen configuration for consumer GPUs
      MIOPEN_USER_DB_PATH = "/var/lib/immich/.config/miopen";
    };
  };
}

