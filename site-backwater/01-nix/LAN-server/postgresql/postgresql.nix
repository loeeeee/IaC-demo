{ config, pkgs, modulesPath, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    postgresql_18
  ];

  # Configure user postgres
  users.groups.postgres = {
    gid = lib.mkForce 2348;
  };
  users.users.postgres = {
    isSystemUser = true;
    uid = lib.mkForce 2348;
    group = "postgres";
    home = lib.mkDefault "/var/lib/postgresql";
    createHome = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    dataDir = "/var/lib/postgresql/data";
    # Listen on all interfaces for now; customize as needed
    settings = {
      listen_addresses = lib.mkDefault "172.22.0.133";

      # Phase 2 Bulk Load Optimizations (from database bottleneck analysis)
      # Memory settings optimized for 4GB RAM container
      max_connections = 500;
      shared_buffers = "8GB";                    # 25% of 32GB RAM (was 128MB)
      work_mem = "256MB";                        # For sorting/hashing (was 4MB)
      maintenance_work_mem = "1GB";              # For index creation/vacuum (was 64MB)

      # Checkpoint optimization for bulk loading
      # This provides 3-5x speedup for COPY operations
      # IMPORTANT: This trades durability for speed - acceptable for bulk index building
      synchronous_commit = "off";                # This trades durability for speed
      checkpoint_timeout = "15min";              # Reduce checkpoint frequency (was 5min)
      max_wal_size = "8GB";                      # Increase WAL size (was ~1GB)
      min_wal_size = "2GB";                      # Increase min WAL size (was 80MB)

      # Additional performance settings
      wal_buffers = "16MB";                      # Increase WAL buffer size
      effective_cache_size = "3GB";              # 75% of RAM for query planner

      # Optimize for SSD
      random_page_cost = "1.1";                  # (default is 4.0 for HDD)

      # ZFS
      full_page_writes="off";
      wal_init_zero="off";
      wal_recycle="off";

      # Extensions
      shared_preload_libraries = "vchord";
    };

    # Create kafka, syslog, and wiki databases and users
    ensureDatabases = [
      "kafka"
      "syslog"
      "wiki"
      "postgres_exporter"
      "lldap"
      "authelia"
      "immich"
    ];
    ensureUsers = [
      {
        name = "kafka";
        ensureDBOwnership = true;
      }
      {
        name = "syslog";
        ensureDBOwnership = true;
      }
      {
        name = "wiki";
        ensureDBOwnership = true;
      }
      {
        name = "postgres_exporter";
        ensureDBOwnership = true;
      }
      {
        name = "lldap";
        ensureDBOwnership = true;
      }
      {
        name = "authelia";
        ensureDBOwnership = true;
      }
      {
        name = "immich";
        ensureDBOwnership = true;
      }
    ];

    # Allow connections from k3s pod network and server nodes
    authentication = ''
      # Allow kafka user to connect from k3s pods
      host kafka kafka 10.42.0.0/16 md5
      # Allow syslog user to connect from k3s pods
      host syslog syslog 10.42.0.0/16 md5
      # Allow wiki user to connect from k3s pods
      host wiki wiki 10.42.0.0/16 md5
      # Allow lldap user to connect from lldap host
      host lldap lldap 172.22.0.115/32 md5
      # Allow authelia user to connect from authelia host
      host authelia authelia 172.22.0.116/32 md5
      # Allow immich user to connect from immich host
      host immich immich 172.22.0.131/32 md5
      # Allow kafka user to connect from k3s server nodes
      host kafka kafka 172.22.0.0/24 md5
      # Allow syslog user to connect from k3s server nodes
      host syslog syslog 172.22.0.0/24 md5
      # Allow wiki user to connect from k3s server nodes
      host wiki wiki 172.22.0.0/24 md5
      # Allow local connections
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';

    extraPlugins = ps: with ps; [
      pgvector    # VectorChord often relies on pgvector types
      vectorchord # The extension itself
    ];
  };

  # Ensure secret directory exists for password files managed outside the repo
  systemd.tmpfiles.rules = [
    "d /etc/secret 0700 root root -"
  ];
}

