{ config, pkgs, lib, ... }:

{
  # Copy EDID file to firmware directory
  # The kernel looks for EDID files in /lib/firmware/edid/ by default
  systemd.tmpfiles.rules = [
    "L+    /lib/firmware/edid/hp_omen_32.bin    -    -    -     -    ${./bin/hp_omen_32-edid.bin}"
  ];

  # Disable QXL virtual display to force usage of AMD GPU
  # After blacklisting QXL, the AMD GPU becomes card0 (previously card1)
  # This prevents the QXL virtual display from being created, forcing all display operations to use the AMD GPU
  boot.blacklistedKernelModules = [ "qxl" ];
  
  # Inject EDID on boot for AMD GPU display connectors
  # After QXL blacklist, AMD GPU is card0 with physical connectors (DP-1, DP-2, DP-3, HDMI-A-1)
  # Using wildcard to apply EDID to all connectors
  # Note: EDID will only be loaded when connectors are detected as "connected"
  # Since connectors are disconnected in headless setup, EDID may not load automatically
  # This is a limitation of the kernel's EDID firmware mechanism
  boot.kernelParams = [
    "drm.edid_firmware=DP-1:edid/hp_omen_32.bin"
    "video=DP-1:e"
  ];
}
