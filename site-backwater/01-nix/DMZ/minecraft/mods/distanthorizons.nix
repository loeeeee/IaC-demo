{ pkgs, ... }:

# Distant Horizons - Level of Detail mod for extended render distance
# Version: 2.4.5-b-1.21.1 for MC 1.21.1 (Fabric/NeoForge)
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/distanthorizons/versions
pkgs.fetchurl {
  name = "DistantHorizons-2.4.5-b-1.21.1-fabric-neoforge.jar";
  url = "https://cdn.modrinth.com/data/uCdwusMi/versions/bLPLghy9/DistantHorizons-2.4.5-b-1.21.1-fabric-neoforge.jar";
  sha256 = "1v4b9spddmb5s3blwyp050h1az0s319qj98xayw76a83r79md098";
}
