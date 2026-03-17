{ pkgs, ... }:

pkgs.fetchurl {
  name = "torch-hit-fabric-1.21-7.1.1.jar";
  url = "https://cdn.modrinth.com/data/zTOq9jEI/versions/7d82aTgZ/torch-hit-fabric-1.21-7.1.1.jar";
  sha256 = "17pk824lnkwibcvmnhy7g8sam7m6hnai5x0qwvvv1hngiskhb3m5";
}
