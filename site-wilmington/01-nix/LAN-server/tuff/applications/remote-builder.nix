{ config, pkgs, ... }:

{
  users.users.builder = {
    isNormalUser = true;
    # Add the public key of your LOCAL machine's root user here
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 REDACTED nix-builder" 
    ];
  };

  nix.settings.trusted-users = [ "builder" ];
}