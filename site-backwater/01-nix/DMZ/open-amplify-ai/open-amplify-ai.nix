{ config, pkgs, lib, ... }:

let
  amplifyAiSrc = builtins.fetchGit {
    url = "https://github.com/loeeeee/open-amplify-ai.git";
    ref = "main";
    rev = "90b546a52b98957b6489cc4856d891e7db367698";
  };
in
{
  imports = [
    "${amplifyAiSrc}/nix/module.nix"
  ];

  services.amplify-ai = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    environmentFile = /etc/secret/amplify-ai.env;
  };

  # Ensure the secret directory exists
  systemd.tmpfiles.rules = [
    "d /etc/secret 0700 root root -"
  ];
}
