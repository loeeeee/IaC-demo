{ config, pkgs, lib, ... }:

{
  services.gatus = {
    enable = true;
    package = pkgs.gatus;
    openFirewall = false;

    settings = {
      web = {
        address = "0.0.0.0";
        port = 8080;
      };

      storage = {
        type = "sqlite";
        path = "/var/lib/gatus/gatus.db";
        maximum-number-of-results = 86400;
        maximum-number-of-events = 1024;
      };

      ui = {
        title = "Backwater Health";
        header = "Backwater Health Dashboard";
      };

      alerting = {
        email = {
          from = "backwater@REDACTED-DOMAIN.TLD";
          host = "172.22.100.111";
          port = 25;
          to = "loe@REDACTED-DOMAIN2.TLD";
          client = {
            insecure = true;
          };
          default-alert = {
            enabled = true;
            description = "Health Check Failed";
            send-on-resolved = true;
            failure-threshold = 3;
            success-threshold = 3;
          };
        };
        discord = {
          webhook-url = "https://discord.com/api/webhooks/REDACTED/REDACTED";
          default-alert = {
            enabled = true;
            description = "Health Check Failed";
            send-on-resolved = true;
            failure-threshold = 3;
            success-threshold = 3;
          };
        };
      };

      endpoints = import ./endpoints/_init_.nix;

      metrics = true;
    };
  };
}
