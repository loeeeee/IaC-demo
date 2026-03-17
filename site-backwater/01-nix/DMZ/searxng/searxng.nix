{ config, pkgs, ... }:

{
  networking.nameservers = [ "172.22.100.1" ];

  services.searx = {
    enable = true;

    settings = {
      server = {
        bind_address = "0.0.0.0";
        port = 8080;
        secret_key = "REDACTED";
      };

      general = {
        debug = false;
        instance_name = "SearXNG";
        public_instance = false;
      };

      search = {
        safe_search = 0;
        default_lang = "en";
      };

      ui = {
        default_theme = "simple";
      };
    };
  };
}
