{ config, pkgs, ... }:

{
  users.users.builder = {
    isNormalUser = true;
    # Add the public key of your LOCAL machine's root user here
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6ZWwnsDZO1EkWbftkT+phLXO0aXl/Y1ze5KHVMQfnC builder@home" 
    ];
  };

  nix.settings = {
    trusted-users = [ "builder" ];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    # supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86_64" ];
  };
}