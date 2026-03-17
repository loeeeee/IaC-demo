{ pkgs, ... }:

[
  (import ./immersive-aircraft.nix { inherit pkgs; })
  (import ./small-ships.nix { inherit pkgs; })
]
