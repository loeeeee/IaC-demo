{
  # Configure Nix to use the binary cache
  nix.settings = {
    substituters = [
      "https://nix.backwater.REDACTED-DOMAIN.TLD"
    ];
    trusted-public-keys = [
      "mirach:Y9fCrBUSnDIQtlb5mlCrmVUCotL32OfRfNeB6zycGbc="
    ];
  };
}
