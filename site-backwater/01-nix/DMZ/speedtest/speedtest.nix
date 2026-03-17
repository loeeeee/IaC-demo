{ config, pkgs, ... }:

{
  services.librespeed = {
    enable = true;
    frontend = {
      enable = true;
      contactEmail = "admin@REDACTED-DOMAIN.TLD";
      servers = [
        {
          name = "Backwater";
          server = "//speed.backwater.REDACTED-DOMAIN.TLD/backend/";
          dlURL = "garbage";
          ulURL = "empty";
          pingURL = "empty";
          getIpURL = "getIP";
        }
      ];
    };
    settings = {
      bind_address = "0.0.0.0";
      listen_port = 8080;
    };
  };
}
