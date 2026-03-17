{
  # Enable ROCm support for GPU acceleration
  # Following pattern from code-server.nix
  hardware.amdgpu.opencl.enable = true;
  nixpkgs.config.allowUnfree = true; # Required for GPU drivers

  # ROCm packages for GPU acceleration
  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.clr.icd
    rocmPackages.rocm-smi
    rocmPackages.rocrand
    libva-utils
  ];

  nixpkgs.overlays = [
    (final: prev: {
      onnxruntime = prev.onnxruntime.override {
        rocmSupport = true; 
      };
    })
  ];

  systemd.services.immich-machine-learning = {
    environment = {
      # ROCm paths for GPU acceleration
      ROCM_PATH = "${pkgs.rocmPackages.clr}";
      CPATH = "${pkgs.rocmPackages.rocrand}/include:${pkgs.rocmPackages.rocblas}/include:${pkgs.rocmPackages.clr}/include";
      HSA_OVERRIDE_GFX_VERSION="11.0.0";


      # 3. Force MIOpen to compile and tune immediately if a kernel is missing
      # MIOPEN_FIND_MODE = "1";
      
      # 4. Disable system database lookup (since consumer cards aren't in it)
      MIOPEN_USER_DB_PATH = "/var/lib/immich/.config/miopen";
      
      # Disable SDMA: Prevents memory copy timeouts on RX 7000 series
      # HSA_ENABLE_SDMA = "0";
      
      # Fix Thread Affinity: Stops the "pthread_setaffinity_np failed" log spam
      # OMP_NUM_THREADS = "1";
      # OMP_PROC_BIND = "false"; 
      # MIOPEN_ENABLE_LOGGING = "1";
      # Additional GPU environment variables if needed
    };
  };

}