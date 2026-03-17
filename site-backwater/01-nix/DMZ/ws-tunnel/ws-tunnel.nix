{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wstunnel ];
}