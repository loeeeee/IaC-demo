{
  # DHCP-DDNS Server (D2) configuration
  # D2 server handles DNS updates on behalf of DHCP servers
  services.kea.dhcp-ddns = {
    enable = true;
    settings = {
      "ip-address" = "127.0.0.1";
      "port" = 53001;
      "dns-server-timeout" = 1000;
      "ncr-protocol" = "UDP";
      "ncr-format" = "JSON";
      "tsig-keys" = builtins.fromJSON (builtins.readFile "/etc/secret/kea-keys.json");
      "forward-ddns" = {
        "ddns-domains" = [
          {
            "name" = "home.REDACTED-DOMAIN.TLD.";
            "key-name" = "kea-ddns-key";
            "dns-servers" = [
              {
                "ip-address" = "172.21.0.128";
                "port" = 53;
              }
            ];
          }
        ];
      };
      "reverse-ddns" = {
        "ddns-domains" = [
          {
            "name" = "21.172.in-addr.arpa.";
            "key-name" = "kea-ddns-key";
            "dns-servers" = [
              {
                "ip-address" = "172.21.0.128";
                "port" = 53;
              }
            ];
          }
        ];
      };
    };
  };
}

