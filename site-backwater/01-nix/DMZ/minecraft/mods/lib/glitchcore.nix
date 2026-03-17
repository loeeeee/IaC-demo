{ pkgs, ... }:

# GlitchCore - A library mod aimed at abstracting mod loaders and providing various utilities
# Version: 2.1.0.0 for MC 1.21.1 (Fabric)
# Required by: Serene Seasons and other Glitchfiend mods
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/glitchcore/versions
pkgs.fetchurl {
  name = "GlitchCore-fabric-1.21.1-2.1.0.0.jar";
  url = "https://cdn.modrinth.com/data/s3dmwKy5/versions/lbSHOhee/GlitchCore-fabric-1.21.1-2.1.0.0.jar";
  sha256 = "0j2x96c4hz4h34bpvjyqdv47wszf0p7krrirrzmj6nvqkdyp5267";
}
