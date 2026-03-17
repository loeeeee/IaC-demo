{ pkgs, ... }:

pkgs.fetchurl {
  name = "smallships-fabric-1.21.1-2.0.0-b2.1.jar";
  url = "https://cdn.modrinth.com/data/rGWEHQrP/versions/BSRcyUiv/smallships-fabric-1.21.1-2.0.0-b2.1.jar";
  sha256 = "6264f2cda17d8f776229af2cc4a63090d102a6efd6a7bcbe2352ba152b835fbd";
}
