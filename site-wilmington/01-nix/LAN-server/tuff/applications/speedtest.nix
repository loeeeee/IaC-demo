{ config, pkgs, ... }:

{
  services.librespeed = {
    enable = true;
    frontend = {
      enable = true;
      contactEmail = "admin@REDACTED-DOMAIN.TLD";
      servers = [
        {
          name = "Wilmington";
          server = "//speed.wilmington.REDACTED-DOMAIN.TLD/backend/";
          dlURL = "garbage";
          ulURL = "empty";
          pingURL = "empty";
          getIpURL = "getIP";
        }
      ];
    };
    settings = {
      bind_address = "127.0.0.1";
      listen_port = 5002;
    };
  };
}
