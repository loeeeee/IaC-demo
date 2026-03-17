{ config, pkgs, ... }:

let
  # Read the HAProxy config file
  haproxyConfig = builtins.readFile ./haproxy.cfg;
in
{
  # HAProxy service
  services.haproxy = {
    enable = true;
    config = haproxyConfig;
  };

  # Create runtime directory for HAProxy socket
  systemd.tmpfiles.rules = [
    "d /run/haproxy 0755 haproxy haproxy -"
  ];
}

