{ pkgs, ... }:

[]
  ++ (import ./combat/_init_.nix { inherit pkgs; })
  ++ (import ./delight/_init_.nix { inherit pkgs; })
  ++ (import ./miscellaneous/_init_.nix { inherit pkgs; })
  ++ (import ./mob-foe/_init_.nix { inherit pkgs; })
  ++ (import ./mob-friend/_init_.nix { inherit pkgs; })
  ++ (import ./qol/_init_.nix { inherit pkgs; })
  ++ (import ./transportation/_init_.nix { inherit pkgs; })
  ++ (import ./technology/_init_.nix { inherit pkgs; })
