{ pkgs, ... }:

[
  (import ./hybrid-aquatic.nix { inherit pkgs; })
  (import ./touhoulittlemaid-orihime.nix { inherit pkgs; })
]