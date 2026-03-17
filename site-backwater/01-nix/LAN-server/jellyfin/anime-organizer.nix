{ config, pkgs, modulesPath, ... }:

let
  # Fetch the private git repository
  animeOrganizerSrc = builtins.fetchGit {
    url = "https://github.com/loeeeee/anime-organizer-llm.git";
    # ref = "HEAD";
  };

  # Create a derivation that installs the scripts
  animeOrganizer = pkgs.stdenv.mkDerivation {
    name = "anime-organizer-llm";
    src = animeOrganizerSrc;

    installPhase = ''
      mkdir -p $out/bin
      if [ -d "$src/scripts" ]; then
        cp -r $src/scripts/* $out/bin/
        chmod +x $out/bin/*
      else
        echo "Warning: scripts/ directory not found in repository"
      fi
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    python3
    animeOrganizer
  ];
}
