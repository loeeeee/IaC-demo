{ config, pkgs, ... }:

{
  services.keepalived = {
    enable = true;
    vrrpInstances = {
      VI_1 = {
        interface = "eth0";
        state = "BACKUP";
        priority = 80;
        virtualRouterId = 51;
        virtualIps = [
          { addr = "172.21.0.50/24"; }
        ];

        # 8 char password
        extraConfig = ''
          authentication {
            auth_type PASS
            auth_pass REDACTED
          }
        '';
      };
    };
  };
}

