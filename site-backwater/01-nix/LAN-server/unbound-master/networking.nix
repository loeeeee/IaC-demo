{ config, pkgs, ... }:

{
    networking.nameservers = [ "172.22.0.1" ];
}