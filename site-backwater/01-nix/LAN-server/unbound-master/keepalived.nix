{ config, pkgs, ... }:

{
  services.keepalived = {
    enable = true;
    vrrpInstances = {
      VI_1 = {
        interface = "eth0";
        state = "MASTER";
        priority = 90;
        virtualRouterId = 51;
        virtualIps = [
          { addr = "172.22.0.50/24"; }
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