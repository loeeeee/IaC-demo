{
  imports = [
    ./internet.nix
    ./development.nix
    ./tools.nix
    ./media.nix
    ./driver.nix
    ./game.nix
    ./office.nix
  ];

  nixpkgs.config.allowUnfree = true;
}