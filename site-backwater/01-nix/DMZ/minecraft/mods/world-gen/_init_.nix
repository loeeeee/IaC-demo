{ pkgs, ... }:

[
  (import ./better-end.nix { inherit pkgs; })
  (import ./better-nether.nix { inherit pkgs; })
  (import ./countereds-terrain-slabs.nix { inherit pkgs; })
  (import ./incendium.nix { inherit pkgs; })
  (import ./nullscape.nix { inherit pkgs; })
  (import ./roadarchitect.nix { inherit pkgs; })
]