{ config, pkgs, ... }:

{
  # WARNING: Invalid configuration will cause lock-outs!

  nix.distributedBuilds = true;
  nix.settings.max-jobs = 0; # Disable local builds

  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  nix.buildMachines = [ {
    hostName = "172.22.100.105"; # Backwater Binary Cache
    sshUser = "builder";
    sshKey = "/etc/nixos/custom-modules/builder";
    system = "x86_64-linux";
    speedFactor = 48;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    protocol = "ssh-ng";
  } 
  # {
  #   hostName = "172.23.0.2"; # Wilmington
  #   sshUser = "builder";
  #   sshKey = "/etc/nixos/custom-modules/builder";
  #   system = "x86_64-linux";
  #   speedFactor = 1;
  #   supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #   protocol = "ssh-ng";
  # }
  ];

  programs.ssh.knownHosts = {
    "172.22.100.105".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtDOEN1ohtiF0a7HqC0/tq98Dsugfi3UdQ6my4mwOgh";
    "172.23.0.2".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFhXu+Z7Ftd53XZGCDVRkp7BQ9Abi1TQiqMEteA6e2H";
  };
}
