{
  # Configure Nix to use the binary cache
  nix.settings = {
    substituters = [
      "https://nix.home.REDACTED-DOMAIN.TLD"
    ];
    trusted-public-keys = [
      "sapporo:rWwfdG5ZF8Hb3fRYrix1ijFJ5mkfjBzROm2KqdSPRCU="
    ];
  };
}
