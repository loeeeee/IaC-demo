{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    prometheus-postgres-exporter
  ];

  services.prometheus.exporters.postgres = {
    enable = true;
    port = 9167;
  };
}

