{ config, pkgs, ... }:

let
  picoclaw = pkgs.buildGoModule {
    pname = "picoclaw";
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "sipeed";
      repo = "picoclaw";
      rev = "4178b2cec5028ab0b86cc0bdd5c0ff0c2ffbca9f";
      hash = "sha256-CxiNEQP1fW2Cnx8+7E/hGi+SXuHg4/GAHdrjvD/vF/w=";
    };
    postPatch = ''
      mkdir -p cmd/picoclaw/internal/onboard/workspace
      echo "" > cmd/picoclaw/internal/onboard/workspace/AGENTS.md
    '';
    doCheck = false;
    proxyVendor = true;
    vendorHash = "sha256-+vNsBFbQor+M4eZW6fs50j3X13qotS9Nt55qkd1Zhcc=";
    go = pkgs.go_1_26;
  };
in
{
  environment.systemPackages = [
    picoclaw
  ];

  # Ensure the secret directory exists with restricted permissions
  systemd.tmpfiles.rules = [
    "d /etc/secret 0700 root root -"
  ];

  users.groups.claw = {
    gid = 2356;
  };

  users.users.claw = {
    isSystemUser = true;
    home = "/var/lib/claw";
    createHome = true;
    uid = 2356;
    group = "claw";
  };

  systemd.services.claw-mahiro = {
    description = "Claw Service for Mahiro";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PICOCLAW_CONFIG = "/var/lib/claw/.picoclaw/config-mahiro.json";
      PICOCLAW_HOME = "/var/lib/claw/.picoclaw";
      HOME = "/var/lib/claw";
      NIX_PATH = "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos";
    };
    path = [ 
      pkgs.procps 
      pkgs.bash 
      pkgs.coreutils 
      pkgs.nix
      "/var/lib/claw/.picoclaw/bin"
    ];

    serviceConfig = {
      ExecStartPre = pkgs.writeShellScript "claw-pre-start" ''
        # Create the bin directory INSIDE the workspace
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/claw/.picoclaw/bin
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/claw/.picoclaw/mahiro/
        
        # Create actual wrapper scripts instead of symlinks to defeat symlink resolution guards
        echo "#!${pkgs.bash}/bin/bash" > /var/lib/claw/.picoclaw/bin/nix-shell
        echo "exec ${pkgs.nix}/bin/nix-shell \"\$@\"" >> /var/lib/claw/.picoclaw/bin/nix-shell
        ${pkgs.coreutils}/bin/chmod +x /var/lib/claw/.picoclaw/bin/nix-shell
        
        # Copy config and mahiro workspace files from secrets
        ${pkgs.coreutils}/bin/cp /etc/secret/config-mahiro.json /var/lib/claw/.picoclaw/config-mahiro.json
        ${pkgs.rsync}/bin/rsync -a /etc/secret/mahiro/*.md /var/lib/claw/.picoclaw/mahiro/

        # Set ownership and permissions on workspace
        ${pkgs.coreutils}/bin/chown claw:claw -R /var/lib/claw/
        ${pkgs.coreutils}/bin/chmod 400 /var/lib/claw/.picoclaw/config-mahiro.json
        ${pkgs.coreutils}/bin/chmod 700 /var/lib/claw/.picoclaw/mahiro/
      '';
      ReadWritePaths = [ "/var/lib/claw" ];
      BindReadOnlyPaths = [ "/nix/store" "/nix/var/nix/db" "/nix/var/nix/daemon-socket" ];
      ExecStart = "${picoclaw}/bin/picoclaw gateway";
      User = "claw";
      Group = "claw";
      Restart = "always";
      WorkingDirectory = "/var/lib/claw";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      StateDirectory = "claw";
    };
  };

  systemd.services.claw-mihari = {
    description = "Claw Service for Mihari";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PICOCLAW_CONFIG = "/var/lib/claw/.picoclaw/config-mihari.json";
      PICOCLAW_HOME = "/var/lib/claw/.picoclaw";
      HOME = "/var/lib/claw";
      NIX_PATH = "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos";
    };
    path = [ 
      pkgs.procps 
      pkgs.bash 
      pkgs.coreutils 
      pkgs.nix
      "/var/lib/claw/.picoclaw/bin"
    ];

    serviceConfig = {
      ExecStartPre = pkgs.writeShellScript "claw-pre-start" ''
        # Create the bin directory INSIDE the workspace
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/claw/.picoclaw/bin
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/claw/.picoclaw/mihari/
        
        # Create actual wrapper scripts instead of symlinks to defeat symlink resolution guards
        echo "#!${pkgs.bash}/bin/bash" > /var/lib/claw/.picoclaw/bin/nix-shell
        echo "exec ${pkgs.nix}/bin/nix-shell \"\$@\"" >> /var/lib/claw/.picoclaw/bin/nix-shell
        ${pkgs.coreutils}/bin/chmod +x /var/lib/claw/.picoclaw/bin/nix-shell
        
        # Copy config and mihari workspace files from secrets
        ${pkgs.coreutils}/bin/cp /etc/secret/config-mihari.json /var/lib/claw/.picoclaw/config-mihari.json
        ${pkgs.rsync}/bin/rsync -a /etc/secret/mihari/*.md /var/lib/claw/.picoclaw/mihari/

        # Set ownership and permissions on workspace
        ${pkgs.coreutils}/bin/chown claw:claw -R /var/lib/claw/
        ${pkgs.coreutils}/bin/chmod 400 /var/lib/claw/.picoclaw/config-mihari.json
        ${pkgs.coreutils}/bin/chmod 700 /var/lib/claw/.picoclaw/mihari/
      '';
      ReadWritePaths = [ "/var/lib/claw" ];
      BindReadOnlyPaths = [ "/nix/store" "/nix/var/nix/db" "/nix/var/nix/daemon-socket" ];
      ExecStart = "${picoclaw}/bin/picoclaw gateway";
      User = "claw";
      Group = "claw";
      Restart = "always";
      WorkingDirectory = "/var/lib/claw";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      StateDirectory = "claw";
    };
  };
}
