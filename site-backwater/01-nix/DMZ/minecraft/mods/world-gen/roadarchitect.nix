{ pkgs, ... }:

pkgs.fetchurl {
  name = "roadarchitect-1.6.2-fabric-1.21.1.jar";
  url = "https://cdn.modrinth.com/data/dLRvLyY3/versions/DrvVjNa3/roadarchitect-1.6.2-fabric%2B1.21.1.jar";
  sha256 = "116zvih65mgdh0mhsr0gq63ragz6wx7gjnabvy61f5myjynkjph1";
}

