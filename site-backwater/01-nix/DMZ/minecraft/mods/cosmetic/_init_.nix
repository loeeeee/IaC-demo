{ pkgs, ... }:

[
  (import ./handcrafted.nix { inherit pkgs; })
  (import ./serene-seasons.nix { inherit pkgs; })
  (import ./snow-real-magic.nix { inherit pkgs; })
  # (import ./cool-rain.nix { inherit pkgs; })
  # (import ./beautiful-enchanted-books.nix { inherit pkgs; })
  # (import ./beautiful-potions.nix { inherit pkgs; })

]
