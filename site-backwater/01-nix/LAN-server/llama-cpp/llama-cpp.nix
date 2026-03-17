{ config, pkgs, modulesPath, lib, ... }:

let
  # 1. Define a variable (myPackage) that imports your custom derivation file.
  # callPackage handles passing in the required dependencies (stdenv, fetchurl, etc.)
  llama-cpp-local = pkgs.callPackage ./packages/llama-cpp.nix {};
in
{
  # Enable ROCm support for GPU acceleration
  hardware.amdgpu.opencl.enable = true;
  nixpkgs.config.allowUnfree = true;

  users.users.llama = {
    isNormalUser = true;
    uid=2344;
    description = "User for running LLM services";
    extraGroups = [ "render" "video" ];
    home="/var/lib/llama/";
  };

  users.groups.llama = {
    gid=2344;
    members=[ "llama" ];
  };

  # Llama.cpp REST server service using built-in module
  services.llama-cpp = {
    enable = true;
    package = llama-cpp-local;
    port = 8080;
    host = "0.0.0.0";
    model = "/var/lib/llama/models/llama.cpp/unsloth_MiniMax-M2-GGUF_Q4_K_M_MiniMax-M2-Q4_K_M-00001-of-00003.gguf";
    extraFlags = [
      "-ngl"
      "999"
      "--n-cpu-moe"
      "60"
      "--jinja"
      "-fa"
      "on"
      "-c"
      "64000"
      "--reasoning-format"
      "auto"
      "-t"
      "36"
      "-ctk"
      "q8_0"
      "-ctv"
      "q8_0"
      "-b"
      "6144"
      "-ub"
      "6144"
      # "--numa"
      # "numactl" # 10 TPS -> 6 TPS
    ];
  };

  systemd.services.llama-cpp.serviceConfig = {
    # Filesystem protections
    # ProtectSystem = lib.mkForce "no";
    # ProtectHome = lib.mkForce false;
    # PrivateTmp = lib.mkForce false;

    # # Kernel and process protections
    # ProtectKernelTunables = lib.mkForce false;
    # ProtectKernelModules = lib.mkForce false;
    # ProtectControlGroups = lib.mkForce false;
    # MemoryDenyWriteExecute = lib.mkForce false;
    # NoNewPrivileges = lib.mkForce false;
    # DynamicUser = lib.mkForce false;
    # SystemCallFilter = lib.mkForce "";
    # PrivateUsers = lib.mkForce false;

    User="llama";
    Group="llama";
    TimeoutStartSec=60;
  };

  # System packages including dependencies
  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.clr.icd
    rocmPackages.rocm-smi
    rocmPackages.rocblas
    rocmPackages.hipblas
    openblas
    vulkan-tools
    amdgpu_top
    code-server
    btop
    curl
    llama-cpp-local
    numactl
  ];
}
