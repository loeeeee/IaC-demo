{ pkgs, ... }:

[
  (import ./appleskin.nix { inherit pkgs; })
  (import ./boat-fall.nix { inherit pkgs; })
  (import ./sit.nix { inherit pkgs; })
  (import ./bow-infinity-fix.nix { inherit pkgs; })
  (import ./carry-on.nix { inherit pkgs; })
  (import ./discord-statusbot.nix { inherit pkgs; })
  (import ./antique-atlas-4.nix { inherit pkgs; })
  (import ./lamb-dynamic-lights.nix { inherit pkgs; })
  (import ./leashable-players.nix { inherit pkgs; })
  (import ./simple-villager-follow.nix { inherit pkgs; })
  (import ./smarter-farmers.nix { inherit pkgs; })
  (import ./torch-hit.nix { inherit pkgs; })
  (import ./watut.nix { inherit pkgs; })
  (import ./yeet.nix { inherit pkgs; })
]