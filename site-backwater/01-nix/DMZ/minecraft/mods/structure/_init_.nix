{ pkgs, ... }:

[
  (import ./ct-overhaul-village.nix { inherit pkgs; })
  (import ./explorify.nix { inherit pkgs; })
  (import ./ati-structures-vanilla.nix { inherit pkgs; })
  (import ./ribbits.nix { inherit pkgs; })
  (import ./philips-ruins.nix { inherit pkgs; })
  (import ./sparse-structures.nix { inherit pkgs; })
  (import ./towns-and-towers.nix { inherit pkgs; })
  (import ./villages-and-pillages.nix { inherit pkgs; })
  (import ./yungs-better-desert-temples.nix { inherit pkgs; })
  (import ./yungs-better-dungeons.nix { inherit pkgs; })
  (import ./yungs-better-end-island.nix { inherit pkgs; })
  (import ./yungs-better-jungle-temples.nix { inherit pkgs; })
  (import ./yungs-better-mineshafts.nix { inherit pkgs; })
  (import ./yungs-better-nether-fortresses.nix { inherit pkgs; })
  (import ./yungs-better-ocean-monuments.nix { inherit pkgs; })
  (import ./yungs-better-strongholds.nix { inherit pkgs; })
  (import ./yungs-better-witch-huts.nix { inherit pkgs; })
  (import ./yungs-bridges.nix { inherit pkgs; })
]
