{ config, pkgs, ... }:

{
  users.users.builder = {
    isNormalUser = true;
    # Add the public key of your LOCAL machine's root user here
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAn2apW4ZpTel7Eir5hurzNRiNhXowKqCT0O9tXDdqiW nix-builder" 
    ];
  };

  nix.settings = {
    trusted-users = [ "builder" ];
    # supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86_64" ];
  };
}