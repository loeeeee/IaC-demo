{ pkgs, ... }:

[
  (import ./immersive-armors.nix { inherit pkgs; })
  (import ./countereds-accurate-hitboxes.nix { inherit pkgs; })
]