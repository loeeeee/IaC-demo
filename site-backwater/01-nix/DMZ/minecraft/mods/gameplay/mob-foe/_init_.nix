{ pkgs, ... }:

[
  (import ./edf-remastered.nix { inherit pkgs; })
  (import ./nyfs-spiders.nix { inherit pkgs; })
  (import ./roadarchitect-encounters.nix { inherit pkgs; })
  (import ./zombie-awareness.nix { inherit pkgs; })
]