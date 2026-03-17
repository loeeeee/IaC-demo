{ config, pkgs, ... }:

{
  # Install Siril - astronomical image processing software
  environment.systemPackages = with pkgs; [
    siril
    exiftool
    darktable
    libraw
    gsettings-desktop-schemas
    xdg-utils

    kstars
  ];
}
