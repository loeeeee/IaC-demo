{ config, pkgs, ... }:

{
  # Add PolyMC overlay to nixpkgs
  nixpkgs.overlays = [
    (import (builtins.fetchTarball "https://github.com/PolyMC/PolyMC/archive/develop.tar.gz")).overlay
  ];

  # Install PolyMC launcher
  environment.systemPackages = with pkgs; [
    polymc
  ];
}
