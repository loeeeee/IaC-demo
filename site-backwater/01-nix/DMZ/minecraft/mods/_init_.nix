{ pkgs, ... }:

[
  (import ./distanthorizons.nix { inherit pkgs; })
  # (import ./my-mod.nix { inherit pkgs; })  # Add your mod here
] ++ (import ./cosmetic/_init_.nix { inherit pkgs; })
  ++ (import ./gameplay/_init_.nix { inherit pkgs; })
  ++ (import ./lib/_init_.nix { inherit pkgs; })
  ++ (import ./optimization/_init_.nix { inherit pkgs; })
  ++ (import ./structure/_init_.nix { inherit pkgs; })
  ++ (import ./world-gen/_init_.nix { inherit pkgs; })