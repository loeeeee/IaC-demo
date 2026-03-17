{ pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    siril
    kdePackages.kdenlive
    kdePackages.krecorder
    kdePackages.gwenview
    gimp
    darktable
    blender
    kstars
    vlc
    obs-studio
    audacity
    fiji
  ];
}