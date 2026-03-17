{
  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.clr.icd
    rocmPackages.rocm-smi
    vulkan-tools
    amdgpu_top


    (ffmpeg_8-full.override {
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
    })
    libva
    libva-utils

      ## Python tools
  (python313.withPackages (python-pkgs:
    let
      torch = python-pkgs.torchWithRocm;
    in with python-pkgs; [
      torch
      (torchaudio.override { inherit torch; })
      (torchvision.override { inherit torch; })
    ]))
  ];

  nixpkgs.config.allowUnfree = true; # FFmpeg codec support
  hardware.amdgpu.opencl.enable = true;
}