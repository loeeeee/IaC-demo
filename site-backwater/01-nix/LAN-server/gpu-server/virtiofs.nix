{ config, pkgs, ... }:

{
  # VirtioFS filesystem mounts
  # These mount Proxmox host directories shared via virtiofs into the VM
  # Mount tags must match the mapping names defined in Proxmox configuration
  # Using nofail to prevent boot failure if virtiofs devices are not ready yet

  # Ensure mount point directories exist with correct ownership
  # UID/GID 102340 matches host filesystem for virtiofs
  systemd.tmpfiles.rules = [
    "d /home/loe/Projects 0755 102340 102340 -"
    "d /home/loe/DigitalMemory 0755 102340 102340 -"
    "d /home/loe/Archives 0755 102340 102340 -"
  ];

  fileSystems."/home/loe/Projects" = {
    device = "loe-Projects";
    fsType = "virtiofs";
    options = [ "rw" "nofail" ];
  };

  fileSystems."/home/loe/DigitalMemory" = {
    device = "loe-DigitalMemory";
    fsType = "virtiofs";
    options = [ "rw" "nofail" ];
  };

  fileSystems."/home/loe/Archives" = {
    device = "loe-Archives";
    fsType = "virtiofs";
    options = [ "rw" "nofail" ];
  };
}
