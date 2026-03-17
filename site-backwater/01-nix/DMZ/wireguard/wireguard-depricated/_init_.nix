{
  # WireGuard configurations have been moved to containers
  # See ../containers/ directory for the new container-based configurations
  imports = [
    # ./remote-access.nix  # Now in ../containers/wg-remote-access.nix
    # ./home.nix           # Currently disabled
    # ./wilmington.nix     # Now in ../containers/wg-wilmington.nix
  ];
}

