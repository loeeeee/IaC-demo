{ config, pkgs, lib, ... }:

let
  # Fetch nix-minecraft from GitHub
  nix-minecraft = builtins.fetchTarball {
    url = "https://github.com/Infinidoge/nix-minecraft/archive/master.tar.gz";
    sha256 = "1q8b1sqhzmzy22irf0x3c64gggywqyk7v8mdw7b7gin1f4g7fmdy";
  };
in
{
  # Import nix-minecraft NixOS module
  imports = [
    (nix-minecraft + "/modules/minecraft-servers.nix")
  ];

  # Add nix-minecraft overlay to access server packages
  nixpkgs.overlays = [
    (import (nix-minecraft + "/overlay.nix"))
  ];

  # Configure minecraft user and group
  users.groups.minecraft = {
    gid = 2357;
  };

  users.users.minecraft = {
    isSystemUser = true;
    uid = 2357;
    group = "minecraft";
    description = "Minecraft server service user";
    home = "/var/lib/minecraft";
    createHome = true;
  };

  # Ensure data directory exists with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft 0755 minecraft minecraft -"
    "d /etc/secret 0700 minecraft minecraft -"
  ];

  # Enable minecraft-servers module
  services.minecraft-servers = {
    enable = true;
    eula = true;  # Accept Mojang's EULA
    dataDir = "/var/lib/minecraft";
    user = "minecraft";
    group = "minecraft";

    servers.survival = {
      enable = true;
      autoStart = true;

      # Use Fabric server pinned to Minecraft 1.21.1 for better mod compatibility
      package = pkgs.fabricServers.fabric-1_21_1.override { jre_headless = pkgs.jdk25_headless; };

      jvmOpts = "-Xms32768M -Xmx32768M -Xss4m -Xshare:off -XX:+DisableExplicitGC -XX:+UseNUMA -XX:+UseZGC -XX:-ZUncommit -XX:+UseLargePages -XX:+UseTransparentHugePages -XX:+UnlockExperimentalVMOptions -XX:-OmitStackTraceInFastThrow -XX:+AlwaysPreTouch -XX:+UnlockDiagnosticVMOptions -XX:+DebugNonSafepoints -Dchunky.maxWorkingCount=256";

      # Server properties
      serverProperties = {
        "server-port" = 25565;
        "motd" = "Loe's World";
        "max-players" = 10;
        "difficulty" = 3;  # Normal
        "gamemode" = 0;    # Survival
        "white-list" = false;
        "enable-rcon" = false;
        "online-mode" = true;
        "enforce-whitelist" = false;
        "spawn-monsters" = true;
        "spawn-animals" = true;
        "spawn-npcs" = true;
        "generate-structures" = true;
        "view-distance" = 8;
        "simulation-distance" = 12;
        "max-world-size" = 29999984;
        "server-name" = "Lassen";
        "level-name" = "world";
        "level-seed" = "";
        "pvp" = true;
        "max-tick-time" = 60000;
        "network-compression-threshold" = 256;
        "max-build-height" = 2032;
        "resource-pack" = "";
        "resource-pack-prompt" = "";
        "resource-pack-sha1" = "";
        "require-resource-pack" = false;
        "use-native-transport" = true;
        "enable-status" = true;
        "broadcast-rcon-to-ops" = true;
        "broadcast-console-to-ops" = true;
        "enable-query" = false;
        "query.port" = 25565;
        "enable-jmx-monitoring" = false;
        "sync-chunk-writes" = true;
        "enable-command-block" = false;
        "max-chained-neighbor-updates" = 1000000;
        "rate-limit" = 0;
        "hardcore" = false;
        "allow-flight" = true;
        "player-idle-timeout" = 0;
        "prevent-proxy-connections" = false;
        "hide-online-players" = false;
        "entity-broadcast-range-percentage" = 100;
        "log-ips" = true;
        "function-permission-level" = 2;
        "op-permission-level" = 4;
      };

      # Restart policy
      restart = "always";

      # Add mods, datapacks, and ops.json using symlinks
      # Mods are organized in the mods/ subdirectory
      # Datapacks are organized in the datapacks/ subdirectory
      symlinks = {
        "mods" = pkgs.linkFarmFromDrvs "mods" (
          import ./mods/_init_.nix { inherit pkgs; }
        );
        # Paxi expects datapacks in config/paxi/datapacks
        "config/paxi/datapacks" = pkgs.linkFarmFromDrvs "paxi-datapacks" (
          import ./datapacks/_init_.nix { inherit pkgs; }
        );
        "ops.json" = pkgs.writeText "ops.json" (builtins.toJSON [
          {
            name = "Loeeeee";
            uuid = "538e6111-48e0-401c-8543-5122720d65c8";
            level = 4;
            bypassesPlayerLimit = true;
          }
        ]);
      };
    };
  };
}
