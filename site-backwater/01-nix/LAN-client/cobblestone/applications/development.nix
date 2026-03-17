{ pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    code-cursor-fhs
    vscodium-fhs
    antigravity-fhs
    intel-ocl
    openvino
    git
    wireshark
  ];
}