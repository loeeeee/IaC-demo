{ config, pkgs, lib, ... }:

{
  # Immich photo management server with ROCm GPU acceleration
  # Database: PostgreSQL at alkaid/172.22.0.133
  # Storage: /mnt/immich-uploads (mounted from Proxmox)
  # Storage: /mnt/immich-cache (mounted from Proxmox)
  # Storage: /mnt/loe-DigitalMemory (mounted from Proxmox)
  # Access: HAProxy at 172.22.100.110 -> port 8080  

  # Create immich user and group with GPU access
  users.groups.immich = {
    gid=2342;
  };

  users.users.immich = {
    isSystemUser = true;
    group = "immich";
    uid=2342;
    description = "Immich photo management user";
    home = "/var/lib/immich";
    createHome = true;
    extraGroups = [ "render" "video" ]; # GPU device access
  };

  # Ensure mount point permissions
  systemd.tmpfiles.rules = [
    "d /mnt/DigitalMemory 0755 immich immich -"
    "d /var/lib/immich 0755 immich immich -"
    "d /etc/secret 0700 immich immich -"
  ];

  # Configure Immich service
  services.immich = {
    enable = true;
    package = pkgs.immich;

    # Network configuration
    host = "172.22.0.131";
    port = 8080;
    openFirewall = false; # Handled by nftables.nft

    # User and group
    user = "immich";
    group = "immich";

    # Storage configuration
    mediaLocation = "/var/lib/immich";

    # Machine learning for facial recognition
    # Disabled - using remote ML service on GPU server (canopus/172.22.0.101:3003)
    machine-learning = {
      enable = false;
    };

    # GPU acceleration devices for ROCm
    # Configure acceleration devices for video transcoding and ML inference
    # accelerationDevices = [
    #   "/dev/dri/renderD128" # Primary GPU render node
    # ];

    # Secrets file for database password and JWT secret
    # Must be created manually with format:
    # DB_PASSWORD=your_database_password
    # JWT_SECRET=your_jwt_secret
    secretsFile = "/etc/secret/immich.env";

    # Environment variables for ROCm/GPU access
    # environment = {
    # };

    # Additional settings
    settings = {
      # Disable version check (optional)
      newVersionCheck = {
        enabled = true;
      };
      # External domain for proper URL generation
      server = {
        externalDomain = "https://photos.backwater.REDACTED-DOMAIN.TLD";
      };
    };
  };
}

