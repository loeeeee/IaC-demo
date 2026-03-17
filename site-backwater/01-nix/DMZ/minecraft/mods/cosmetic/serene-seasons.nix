{ pkgs, ... }:

# Serene Seasons - Seasons with changing colors, shifting temperatures, and more!
# Version: 10.1.0.1 for MC 1.21.1 (Fabric)
# Requires: GlitchCore, Fabric API
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/serene-seasons/versions
pkgs.fetchurl {
  name = "SereneSeasons-fabric-1.21.1-10.1.0.1.jar";
  url = "https://cdn.modrinth.com/data/e0bNACJD/versions/UqA7miTT/SereneSeasons-fabric-1.21.1-10.1.0.1.jar";
  sha256 = "0706wjakg75wa9zwb1mwf4gwkwnbj3730m7ypba5501agbdv7qy1";
}
