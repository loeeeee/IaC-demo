{
  # Configure Nix to use the binary cache
  nix.settings = {
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://nix.home.REDACTED-DOMAIN.TLD"
    ];
    # trusted-public-keys = [
    #   "mirach:Y9fCrBUSnDIQtlb5mlCrmVUCotL32OfRfNeB6zycGbc="
    # ];
  };
}
