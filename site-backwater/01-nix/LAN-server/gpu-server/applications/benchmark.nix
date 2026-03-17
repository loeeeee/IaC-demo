{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdiskmark
  ];
  services.iperf3.enable = true;
}