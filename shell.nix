{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python313.withPackages (python-pkgs: with python-pkgs; [
    tqdm
    pyyaml
  ]);
in
pkgs.mkShell {
  packages = [
    pythonEnv
    pkgs.rsync
    pkgs.openssh
  ];
}

