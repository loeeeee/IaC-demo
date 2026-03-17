{ config, pkgs, ... }:

{
  # Enable ROCm support for GPU acceleration
  hardware.amdgpu.opencl.enable = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config = { 
    allowUnfree = true;
    rocmTargets = [ "gfx1100" ];
  };

  # Enable graphics hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For compatibility with 32-bit applications
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.clr.icd  # ROCm OpenCL ICD for AMD GPU compute
    ];
  };

  # Overclocking
  boot.kernelParams = [
    # "amdgpu.runpm=0"
    "amdgpu.ppfeaturemask=0xfffd3fff" # Enable all performance features
    "amdgpu.aspm=0"
    "amdgpu.dcdebugmask=0x10"
    "tsc=reliable"
    # "amdgpu.sdma=0"
    # "amdgpu.dc=0"
    # "amdgpu.mes=0"
  ];
  services.lact.enable = true;
  # hardware.amdgpu.overdrive.enable = true;

  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  # ROCm packages for GPU acceleration
  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
    rocmPackages.rocrand
    rocmPackages.rocblas
    vulkan-tools
    amdgpu_top
    libva
    libva-utils
    pciutils
    clinfo
    ocl-icd
    lact

    # (ffmpeg_8-full.override {
    #   withVaapi = true;
    #   withGPL = true;
    #   withGPLv3 = true;
    #   withX265 = true;
    #   withUnfree = true;
    #   withMetal = false;
    #   withMfx = false;
    #   withTensorflow = false;
    #   withSmallBuild = false;
    #   withDebug = false;
    # })

    ## Python tools with ROCm support
    # (python313.withPackages (python-pkgs:
    #   let
    #     torch = python-pkgs.torchWithRocm;
    #   in with python-pkgs; [
    #     torch
    #     (torchaudio.override { inherit torch; })
    #     (torchvision.override { inherit torch; })
    #   ]))
  ];

  # # Environment variables for GPU access
  environment.sessionVariables = {
  #   ROCM_PATH = "${pkgs.rocmPackages.clr}";
  #   HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    OCL_ICD_VENDORS="/run/opengl-driver/etc/OpenCL/vendors";
  };
}

