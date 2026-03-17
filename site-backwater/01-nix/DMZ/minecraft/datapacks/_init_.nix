{ pkgs, ... }:

[
  (import ./jjthunder.nix { inherit pkgs; })
  (import ./terrainslabs-fixes.nix { inherit pkgs; })
]
