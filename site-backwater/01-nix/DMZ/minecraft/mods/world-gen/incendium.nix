{ pkgs, ... }:

# Incendium - Nether biome and structure overhaul
# Version: 5.4.4 for MC 1.21.x (Fabric/Forge/NeoForge/Quilt)
# Update version and hash if Minecraft version changes
# Get version from: https://modrinth.com/mod/incendium/versions
pkgs.fetchurl {
  name = "Incendium_1.21.x_v5.4.4.jar";
  url = "https://cdn.modrinth.com/data/ZVzW5oNS/versions/7mVvV9Th/Incendium_1.21.x_v5.4.4.jar";
  sha256 = "1x2nwsy6kmc4jb2j6j91vndwffbsf9nk3jbzbwbz5493zrllyni8";
}
