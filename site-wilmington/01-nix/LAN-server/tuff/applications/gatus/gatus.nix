{ config, pkgs, lib, ... }:

{
  services.gatus = {
    enable = true;
    package = pkgs.gatus;
    openFirewall = false;

    settings = {
      web = {
        address = "127.0.0.1";
        port = 5001;
      };

      storage = {
        type = "sqlite";
        path = "/var/lib/gatus/gatus.db";
        maximum-number-of-results = 86400;
        maximum-number-of-events = 1024;
      };

      ui = {
        title = "Wilmington Health";
        header = "Wilmington Health Dashboard";
      };

      alerting = {
        email = {
          from = "wilmington@REDACTED-DOMAIN.TLD";
          host = "mail.REDACTED-DOMAIN.TLD";
          port = 465;
          to = "loe@REDACTED-DOMAIN2.TLD";
          username = "wilmington";
          password = "REDACTED";
          client = {
            insecure = false;
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
