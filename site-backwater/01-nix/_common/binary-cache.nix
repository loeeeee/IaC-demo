{
  # Configure Nix to use the binary cache
  nix.settings = {
    substituters = [
      "https://nix.backwater.REDACTED-DOMAIN.TLD"
    ];
    trusted-public-keys = [
      "calaveras:wrOOvfbt4KLy+aB8kL4BAifuMvs8OdGaEQADvxe9B6A="
    ];
  };
}

