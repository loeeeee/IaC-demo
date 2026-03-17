{ pkgs, ... }:

pkgs.fetchurl {
  name = "prickle-fabric-1.21.1-21.1.11.jar";
  url = "https://cdn.modrinth.com/data/aaRl8GiW/versions/Ef7P6Rb7/prickle-fabric-1.21.1-21.1.11.jar";
  sha256 = "d6d639078aecb72770f287d8253e4634114e2536ac9a2ad6ec5f442eb27dd07f";
}
