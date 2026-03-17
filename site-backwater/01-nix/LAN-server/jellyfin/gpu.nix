{
  hardware.graphics.enable = true;
  
  # System packages including dependencies
  environment.systemPackages = with pkgs; [
    libva
    libva-utils
  ];

  services.jellyfin = {
    enable = true;
    package = pkgs.jellyfin.override {
      "jellyfin-ffmpeg" = (pkgs.ffmpeg_8-full.override {
        withVaapi = true;
        withGPL = true;
        withGPLv3 = true;
        withX265 = true;
        withUnfree = true; # Allow unfree dependencies (for Nvidia features notably)
        withMetal = false; # Use Metal API on Mac. Unfree and requires manual downloading of files
        withMfx = false; # Hardware acceleration via the deprecated intel-media-sdk/libmfx. Use oneVPL instead (enabled by default) from Intel's oneAPI.
        withTensorflow = false; # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
        withSmallBuild = false; # Prefer binary size to performance.
        withDebug = false; # Build using debug options
      });
    };
  };
}