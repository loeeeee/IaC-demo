{ config, pkgs, ... }:

{
  # WARNING: Invalid configuration will cause lock-outs!

  # nix.distributedBuilds = false; # Avoid dependency loops

  programs.ssh.knownHosts = {
    "172.22.100.105".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtDOEN1ohtiF0a7HqC0/tq98Dsugfi3UdQ6my4mwOgh";
  };
}