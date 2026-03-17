{ pkgs, ... }:

pkgs.fetchurl {
  name = "worldweaver-21.0.13.jar";
  url = "https://cdn.modrinth.com/data/RiN8rDVs/versions/mPmeykPR/worldweaver-21.0.13.jar";
  sha256 = "2c408d36e70290b840faec12a963c4b3efb38391de3c87d73228d3ce76bf132d";
}
