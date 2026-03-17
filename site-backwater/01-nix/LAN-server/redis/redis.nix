{ config, pkgs, modulesPath, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    redis
  ];

  # Configure user redis
  users.groups.redis = {
    gid = lib.mkForce 2355;
  };
  users.users.redis = {
    isSystemUser = true;
    uid = lib.mkForce 2355;
    group = "redis";
    home = lib.mkDefault "/var/lib/redis";
    createHome = true;
  };

  services.redis.package = pkgs.redis;

  services.redis.servers.main = {
    enable = true;
    bind = "172.22.0.140";
    port = 6379;
    user = "redis";
    group = "redis";
    logLevel = "notice";
    openFirewall = false; # Handled by nftables.nft

    # Persistence configuration
    save = [
      [900 1]    # Save if at least 1 key changed in 900 seconds
      [300 10]   # Save if at least 10 keys changed in 300 seconds
      [60 10000] # Save if at least 10000 keys changed in 60 seconds
    ];
    appendOnly = true;
    appendFsync = "everysec";

    # Configure Redis settings appropriate for 4GB RAM container
    settings = {
      # Memory management
      maxmemory = "3gb";  # Leave ~1GB for system
      maxmemory-policy = "allkeys-lru";  # Evict least recently used keys when memory limit reached

      # Network
      tcp-backlog = 511;
      timeout = 0;  # Disable client timeout

      # Security
      protected-mode = "no";  # Disable protected mode since we're using firewall
    };
  };

  # Redis server instance for Immich
  services.redis.servers.immich = {
    enable = true;
    bind = "172.22.0.140";
    port = 6380;  # Different port to separate from main instance
    user = "redis";
    group = "redis";
    logLevel = "notice";
    openFirewall = false; # Handled by nftables.nft

    # Persistence configuration
    save = [
      [900 1]    # Save if at least 1 key changed in 900 seconds
      [300 10]   # Save if at least 10 keys changed in 300 seconds
      [60 10000] # Save if at least 10000 keys changed in 60 seconds
    ];
    appendOnly = true;
    appendFsync = "everysec";

    # Configure Redis settings for Immich caching
    settings = {
      # Memory management - dedicated for Immich
      maxmemory = "2gb";  # Allocate 2GB for Immich cache
      maxmemory-policy = "allkeys-lru";  # Evict least recently used keys when memory limit reached

      # Network
      tcp-backlog = 511;
      timeout = 0;  # Disable client timeout

      # Security
      protected-mode = "no";  # Disable protected mode since we're using firewall
    };
  };

  # Ensure data directory permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/redis 0755 redis redis -"
    "d /etc/secret 0700 redis redis -"
  ];
}

