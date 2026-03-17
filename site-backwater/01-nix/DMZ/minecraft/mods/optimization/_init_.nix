{ pkgs, ... }:

[
  (import ./alternate-current.nix { inherit pkgs; })
  (import ./c2me.nix { inherit pkgs; })
  (import ./krypton.nix { inherit pkgs; })
  (import ./lithium.nix { inherit pkgs; })
  (import ./noisium.nix { inherit pkgs; })
  (import ./scalablelux.nix { inherit pkgs; })
]
