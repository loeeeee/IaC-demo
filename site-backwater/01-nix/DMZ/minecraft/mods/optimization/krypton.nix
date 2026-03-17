{ pkgs, ... }:

pkgs.fetchurl {
  name = "krypton-0.2.8.jar";
  url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
  sha256 = "94f195819b24e5da64effdc9da15cdd84836cc75e8ff0fd098bab6bc2f49e3fe";
}
