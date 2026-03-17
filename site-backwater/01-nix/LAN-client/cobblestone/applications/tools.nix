{ pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    solaar
    libva-utils
    vulkan-tools
    networkmanager
    kdePackages.kdeconnect-kde
  ];
}