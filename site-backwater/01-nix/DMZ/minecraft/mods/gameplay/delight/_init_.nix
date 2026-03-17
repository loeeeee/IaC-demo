{ pkgs, ... }:

[
  (import ./chefs-delight.nix { inherit pkgs; })
  (import ./ends-delight.nix { inherit pkgs; })
  (import ./farmers-delight.nix { inherit pkgs; })
  (import ./more-delight.nix { inherit pkgs; })
  (import ./oceans-delight.nix { inherit pkgs; })
  (import ./rustic-delight.nix { inherit pkgs; })
  (import ./ubes-delight.nix { inherit pkgs; })
]