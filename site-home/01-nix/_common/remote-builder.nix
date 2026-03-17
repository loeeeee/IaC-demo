{ config, pkgs, ... }:

{
  # WARNING: Invalid configuration will cause lock-outs!

  nix.distributedBuilds = true;
  nix.settings.max-jobs = 0; # Disable local builds

  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  nix.buildMachines = [ {
    hostName = "172.21.1.101"; # Sapporo Binary Cache
    sshUser = "builder";
    sshKey = "/etc/nixos/custom-modules/builder@home";
    system = "x86_64-linux";
    maxJobs = 56;
    speedFactor = 14;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    protocol = "ssh-ng";
  } 
  # {
  #   hostName = "172.23.0.2"; # Wilmington
  #   sshUser = "builder";
  #   sshKey = "/etc/nixos/custom-modules/builder";
  #   system = "x86_64-linux";
  #   maxJobs = 2;
  #   speedFactor = 2;
  #   supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #   protocol = "ssh-ng";
  # }
  ];

  programs.ssh.knownHosts = {
    "172.21.1.101".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOsAqd0hYFycUX4l4hLLFM8tMS47dAEO+lCBTHfafrn2 builder@home";
  };
}