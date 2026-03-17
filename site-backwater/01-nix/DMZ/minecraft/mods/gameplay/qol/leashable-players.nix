{ pkgs, ... }:

pkgs.fetchurl {
  name = "leashmod-1.1.0.jar";
  url = "https://cdn.modrinth.com/data/BKyMf6XK/versions/ikLeZ0BV/leashmod-1.1.0.jar";
  sha256 = "4a675ac9a99bc85daf60734966ebe75ba20c2785167febad2e72d37a7ba0a510";
}
