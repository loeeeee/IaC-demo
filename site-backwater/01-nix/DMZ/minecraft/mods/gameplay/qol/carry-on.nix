{ pkgs, ... }:

pkgs.fetchurl {
  name = "carryon-fabric-1.21.1-2.2.4.4.jar";
  url = "https://cdn.modrinth.com/data/joEfVgkn/versions/dmotghAy/carryon-fabric-1.21.1-2.2.4.4.jar";
  sha256 = "968ebd25576aaee7dcf1e839956e3749302a74516c55f9e3b8b5a3e4d1cf251b";
}
