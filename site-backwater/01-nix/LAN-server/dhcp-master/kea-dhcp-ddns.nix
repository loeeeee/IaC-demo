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
            "name" = "backwater.REDACTED-DOMAIN.TLD.";
            "key-name" = "kea-ddns-key";
            "dns-servers" = [
              {
                "ip-address" = "172.22.0.110";
                "port" = 53;
              }
            ];
          }
        ];
      };
      "reverse-ddns" = {
        "ddns-domains" = [
          {
            "name" = "22.172.in-addr.arpa.";
            "key-name" = "kea-ddns-key";
            "dns-servers" = [
              {
                "ip-address" = "172.22.0.110";
                "port" = 53;
              }
            ];
          }
        ];
      };

      "loggers" = [
        {
          "name" = "kea-dhcp-ddns";
          "output-options" = [
            {
              "output" = "/var/log/kea/kea-dhcp-ddns.log";
              "maxver" = 10;
              "maxsize" = 10485760;
            }
          ];
          "severity" = "INFO";
        }
      ];
    };
  };
}