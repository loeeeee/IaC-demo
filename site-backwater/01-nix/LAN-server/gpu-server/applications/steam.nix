{ config, pkgs, ... }:

{
  # Enable Steam with gamescope support
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Add gaming packages
  environment.systemPackages = with pkgs; [
    gamescope
    vulkan-tools
    mesa-demos
    libva-utils

    protonup-qt
    
    kdePackages.krecorder
  ];
}

